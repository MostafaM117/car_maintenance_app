import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Delete Account 
Future <void> deleteAccount(BuildContext context) async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    if(user == null){ 
      return;
      }
    try{
      AuthCredential credential;
      //Reauth
      if(user.providerData.any((info)=> info.providerId == "google.com")){
        //Google Reauth
        final GoogleSignIn Gsignin = GoogleSignIn();
        final GoogleSignInAccount? GUser = await Gsignin.signIn();
        if(GUser == null){
          throw FirebaseAuthException(code: "ERROR_ABORTED_BY_USER");
        }
        final GoogleSignInAuthentication googleAuth = await GUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else if(user.email != null){
        String email = user.email!;
        String? password = await showPasswordDialog(context);
        if(password == null) return;
        credential = EmailAuthProvider.credential(email: email, password: password);
      }
      else{
        throw FirebaseAuthException(code: "UNKNOWN_PROVIDER");
      }
      await user.reauthenticateWithCredential(credential);
      await firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await auth.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> RedirectingPage()), (route)=> false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account deleted successfully.")));
    }
    catch(e){
      if(e.toString().contains('supplied auth credential is incorrect')){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect password. Please try again.")));
        showPasswordDialog(context);
      }
      else if(e.toString().contains('channel-error')){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("password can\'t be empty")));
        showPasswordDialog(context);
      }

      else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
      print(e.toString());
    }
  }

  // Show Password Dialog
  Future<String?> showPasswordDialog(BuildContext context) async {
    TextEditingController passwordcontroller = TextEditingController();
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Enter Your Password to confirm"),
          content: TextField(
            controller: passwordcontroller,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"), 
              onPressed: (){
                Navigator.pop(context);
              },),
              TextButton(child: Text("Confirm"),
              onPressed: (){
                Navigator.pop(context, passwordcontroller.text);
              },)
          ],
          );
      });
  }