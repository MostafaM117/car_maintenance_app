import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
import 'package:car_maintenance/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  void _showSnackBar(BuildContext context, String message, Color color, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: color, 
        duration: duration,)
        );
  }

  _suitableErrorMessage(String errorcode){
    switch (errorcode) {
      case "invalid-email": return "Please enter a valid email address";
      case "invalid-credential": return "Incorrect email or Password";
      case "too-many-requests": return "This device is temporarily blocked, try again later.";
      case "network-request-failed":
        return "Network error. Please check your connection.";
      default: return "An error occurred while trying to sign in, try again later.";
    }
  }
  // _getUserPassword 
  Future <String> _getUserPassword(BuildContext context) async{
    final TextEditingController passwordcontroller = TextEditingController();
    String? errorText;
    final result = await showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState){
            
          return AlertDialog(
            title: Text('Enter Your Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('It\'s your first time using google sign in, please enter your password'),
                SizedBox(height: 12,),
                TextField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText: errorText,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: (){
                final password = passwordcontroller.text.trim();
                if(password.isEmpty){
                    setState((){
                    errorText = "Password can't be empty.";
                    });
                    return;
                  }
                else {
                  Navigator.of(context).pop(password);
                  
                  }
              }, child: Text('Link my account')),
              TextButton(
                onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text('Cancel'))
              ],
          );
          }
        );
      });
      return result;
  }
  // Linking Accounts
  Future<void> _linkaccounts(BuildContext context, String email, AuthCredential googlecredential, String docId) async{
    try{
      final password = await _getUserPassword(context);
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      
      await userCredential.user!.linkWithCredential(googlecredential);
      final uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'googleUser': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google account linked successfully.'), backgroundColor: Colors.green,),
      );
      Navigator.of(context).pop();
      } catch(e){
      print('error: $e');
      if(e.toString().contains('firebase_auth/invalid-credential')){

      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password is not correct'), backgroundColor: Colors.red,),
    );
      }
      else{

      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to link accounts, try again or use email and password to sign in')),
    );
      }
    }
  }

  // signInWithGoogle
  Future<UserCredential?> signInWithGoogle (BuildContext context) async{
    try{
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if(gUser == null){
      _showSnackBar(context, 'Google Sign In Canceled', Colors.red, Duration(milliseconds: 2200));
      throw Exception('Google Sign In Canceled');
    }
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    final email = gUser.email;
    final usersRef = FirebaseFirestore.instance.collection('users');
    final userDocQuery = await usersRef.where('email', isEqualTo: email).get();
    //Check for new users
    if(userDocQuery.docs.isNotEmpty){
      final docId = userDocQuery.docs.first.id;
      final googleuserexists = userDocQuery.docs.first.data()['googleUser']?? false;

      if(googleuserexists == true){

    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null){
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
    final userExists = await userDoc.get();
      if (userExists.exists){
      _showSnackBar(context, 'Signed in Successfully', Colors.green.shade400, Duration(milliseconds: 2500));
      }
      else if (!userExists.exists) {
      _showSnackBar(context, 'Welcome, Complete Your first time setup', Colors.green.shade400, Duration(milliseconds: 4000));
      }
    Navigator.pop(context);
    }
    return userCredential;
    } 
    else {
      await _linkaccounts(context, email, credential, docId);
      print('trying to link');
    }
      } else {
        print('User not found');
      }
    } catch(e){
      if(e.toString() == 'Exception: Google Sign In Canceled'){
        print("handled error in Google sign");
      }
      else if(e.toString().contains('network_error')) {
        _showSnackBar(context, 'Network error. Please check your connection.', Colors.red, Duration(milliseconds: 4000));
        throw Exception('Network request failed');
      }
      else {
        print("err:"  + e.toString());
      _showSnackBar(context, e.toString(), Colors.red, Duration(milliseconds: 4000));
        }
    }
    return null;
  }

  // signInWithEmailAndPassword
  Future<UserCredential> signInWithEmailAndPassword(BuildContext context ,String email, password)async{
    if (email.isEmpty){
      _showSnackBar(context, 'An email address is required', Colors.grey.shade700, Duration(milliseconds: 3000));
    throw Exception("Empty email address");
    }
    else if (password.isEmpty){
      _showSnackBar(context, 'Please enter your password', Colors.grey.shade700, Duration(milliseconds: 3000));
    throw Exception("Empty password");
    }
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _showSnackBar(context, 'Signed in successfully', Colors.green.shade400, Duration(milliseconds: 1000));
      Navigator.pop(context);
      return userCredential;
    } on FirebaseAuthException catch(e){
      String errorMessage = _suitableErrorMessage(e.code);
      _showSnackBar(context, errorMessage, Colors.red, Duration(milliseconds: 3000));
      throw Exception(errorMessage);
    }
  }
  // Sign out
  Future<void> signOut(BuildContext context) async {
    try{
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      _showSnackBar(context, 'Signed out', Colors.red, Duration(milliseconds: 2000));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RedirectingPage()), (route) => false );
    } catch(e){
      print("Error while signing out: $e");
      _showSnackBar(context, e.toString(), Colors.red, Duration(milliseconds: 3000));
    }
  }
}