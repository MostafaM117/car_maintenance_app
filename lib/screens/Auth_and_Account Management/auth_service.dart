import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
// import 'package:car_maintenance/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_widgets.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  bool _obscureText = true;

  // void _toggletoviewpassword() {
  //   {
  //     _obscureText = !_obscureText;
  //   }
  // }

  void _showSnackBar(
      BuildContext context, String message, Color color, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration,
    ));
  }

  _suitableErrorMessage(String errorcode) {
    switch (errorcode) {
      case "invalid-email":
        return "Please enter a valid email address";
      case "invalid-credential":
        return "Incorrect email or Password";
      case "too-many-requests":
        return "This device is temporarily blocked, try again later.";
      case "network-request-failed":
        return "Network error. Please check your connection.";
      default:
        return "An error occurred while trying to sign in, try again later.";
    }
  }

  // _getUserPassword
  Future<String> _getUserPassword(BuildContext context) async {
    final TextEditingController passwordcontroller = TextEditingController();
    String? errorText;
    final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.secondaryText,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Please enter your password.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'It’s your first time using Google sign in. Please confirm your password.',
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordcontroller,
                      obscureText: _obscureText,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        errorText: errorText,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.secondaryText),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.secondaryText),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                buildButton(
                  onPressed: () {
                    final password = passwordcontroller.text.trim();
                    if (password.isEmpty) {
                      setState(() {
                        errorText = "Password can't be empty.";
                      });
                    } else {
                      Navigator.of(context).pop(password);
                    }
                  },
                  'Link account',
                  AppColors.secondaryText,
                  AppColors.buttonColor,
                ),
                const SizedBox(height: 15),
                buildButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  'Cancel',
                  AppColors.primaryText,
                  AppColors.buttonText,
                ),
              ],
            );
          });
        });
    return result;
  }

  // Linking Accounts
  Future<void> _linkaccounts(BuildContext context, String email,
      AuthCredential googlecredential, String docId,
      {required String role}) async {
    try {
      final collection = FirebaseFirestore.instance
          .collection(role == 'user' ? 'users' : 'sellers');
      // final existingDoc = await collection.doc(docId).get();
      // if(existingDoc.exists){}
      final password = await _getUserPassword(context);
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      await userCredential.user!.linkWithCredential(googlecredential);
      final uid = userCredential.user!.uid;
      await collection.doc(uid).update({
        'googleUser': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google account linked successfully.'),
          backgroundColor: Colors.green.shade400,
        ),
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print('error: $e');
      if (e.toString().contains('firebase_auth/invalid-credential')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password is not correct'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to link accounts, try again or use email and password to sign in')),
        );
      }
    }
  }

  // signInWithGoogle
  Future<UserCredential?> signInWithGoogle(BuildContext context,
      {required String role}) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        _showSnackBar(context, 'Google Sign In Canceled', Colors.red,
            Duration(milliseconds: 2200));
        throw Exception('Google Sign In Canceled');
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final email = gUser.email;
      final collection = role == 'user' ? 'users' : 'sellers';
      final oppositeCollection = role == 'user' ? 'sellers' : 'users';
      final usersRef = FirebaseFirestore.instance.collection(collection);
      final userDocQuery =
          await usersRef.where('email', isEqualTo: email).get();
      final wrongRoleQuery = await FirebaseFirestore.instance
          .collection(oppositeCollection)
          .where('email', isEqualTo: email)
          .get();
      if (wrongRoleQuery.docs.isNotEmpty) {
        _showSnackBar(
            context,
            'This account is registered as a ${role == 'user' ? 'seller' : 'user'}. Please use the correct login screen.',
            Colors.red,
            Duration(milliseconds: 3000));
        return null;
      }
      //Check for Previously registered users
      if (userDocQuery.docs.isNotEmpty) {
        final docId = userDocQuery.docs.first.id;
        final googleuserexists = userDocQuery.docs.first.data()['googleUser'];

        if (googleuserexists == true) {
          UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          User? user = userCredential.user;

          if (user != null) {
            final userDoc = FirebaseFirestore.instance
                .collection(collection)
                .doc(userCredential.user!.uid);
            final userExists = await userDoc.get();
            if (userExists.exists) {
              _showSnackBar(context, 'Signed in Successfully',
                  Colors.green.shade400, Duration(milliseconds: 2500));
            } else if (!userExists.exists) {
              _showSnackBar(context, 'Welcome, Complete Your first time setup',
                  Colors.green.shade400, Duration(milliseconds: 4000));
            }
            Navigator.pop(context);
            Navigator.pop(context);
          }
          return userCredential;
        } else {
          await _linkaccounts(context, email, credential, docId, role: role);
          print('trying to link');
        }
      }
      //New Users Signing in With Google
      else {
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          final newUserDoc = FirebaseFirestore.instance
              .collection(collection)
              .doc(userCredential.user!.uid);
          String? fullname = user.displayName;
          String? username = fullname?.replaceAll('_', ' ');
          if (role == 'user') {
            await newUserDoc.set({
              'email': user.email,
              'googleUser': true,
              'uid': user.uid,
              'role': 'user',
              'username': username,
              'carAdded': false,
            });
          } else {
            await newUserDoc.set({
              'email': user.email,
              'googleUser': true,
              'uid': user.uid,
              'role': 'seller',
              'username': username,
              'businessname': 'seller',
            });
          }
          _showSnackBar(
              context,
              'Welcome, its your first time to sign in with google',
              Colors.green.shade400,
              Duration(milliseconds: 2500));
          Navigator.pop(context);
          Navigator.pop(context);
        }
        print('New User using Sign in with Google');
        return userCredential;
      }
    } catch (e) {
      if (e.toString() == 'Exception: Google Sign In Canceled') {
        print("handled error in Google sign");
      } else if (e.toString().contains('network_error')) {
        _showSnackBar(context, 'Network error. Please check your connection.',
            Colors.red, Duration(milliseconds: 4000));
        throw Exception('Network request failed');
      } else {
        print("err:" + e.toString());
        _showSnackBar(
            context, e.toString(), Colors.red, Duration(milliseconds: 4000));
      }
    }
    return null;
  }

  // signInWithEmailAndPassword
  Future<UserCredential?> signInWithEmailAndPassword(BuildContext context,
      String email, String password, String expectedRole) async {
    if (email.isEmpty) {
      _showSnackBar(context, 'An email address is required',
          Colors.grey.shade700, Duration(milliseconds: 3000));
      throw Exception("Empty email address");
    } else if (password.isEmpty) {
      _showSnackBar(context, 'Please enter your password', Colors.grey.shade700,
          Duration(milliseconds: 3000));
      throw Exception("Empty password");
    }
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      //check for role Before Redirecting
      final uid = userCredential.user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final sellerDoc =
          await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
      DocumentSnapshot? correctDoc;
      // final docSnapshot = await docRef.get();
      if (userDoc.exists) {
        correctDoc = userDoc;
      } else if (sellerDoc.exists) {
        correctDoc = sellerDoc;
      }
      if (correctDoc == null || !correctDoc.exists) {
        // No document found in either collection
        await FirebaseAuth.instance.signOut();
        _showSnackBar(context, 'Account record not found.', Colors.red,
            Duration(milliseconds: 3000));
        return null;
      }
      final actualrole = correctDoc['role'];
      if (actualrole != expectedRole) {
        await FirebaseAuth.instance.signOut();
        _showSnackBar(
            context,
            'This account is registered as a $actualrole. Please use the correct login screen.',
            Colors.red,
            Duration(milliseconds: 3000));
        return null;
      }
      _showSnackBar(context, 'Signed in Successfully', Colors.green.shade400,
          Duration(milliseconds: 1500));
      Navigator.pop(context);
      Navigator.pop(context);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _suitableErrorMessage(e.code);
      _showSnackBar(
          context, errorMessage, Colors.red, Duration(milliseconds: 3000));
      throw Exception(errorMessage);
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      _showSnackBar(
          context, 'Signed out', Colors.red, Duration(milliseconds: 2000));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RedirectingPage()),
          (route) => false);
    } catch (e) {
      print("Error while signing out: $e");
      _showSnackBar(
          context, e.toString(), Colors.red, Duration(milliseconds: 3000));
    }
  }
}
