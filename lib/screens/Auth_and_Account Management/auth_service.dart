import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
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
    //Check for new users
    return userCredential;
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