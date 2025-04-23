import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/custom_widgets.dart';

class DeleteAccount {
  final passwordcontroller = TextEditingController();
  bool _obscureText = true;

// Loading Indicator while deleting
  void showLoadingIndicator(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void dismissLoadingIndicator(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _toggletoviewpassword() {
    {
      _obscureText = !_obscureText;
    }
    ;
  }

// Delete Account
  Future<void> deleteAccount(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    try {
      AuthCredential credential;
      showLoadingIndicator(context);
      //Reauthentication
      if (user.providerData.any((info) => info.providerId == "google.com")) {
        //Google Reauth
        final GoogleSignIn Gsignin = GoogleSignIn();
        await Gsignin.signOut();
        final GoogleSignInAccount? GUser = await Gsignin.signIn();
        if (GUser == null) {
          dismissLoadingIndicator(context);
          // Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Reauthentication Canceled"),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 2200),
          ));
          throw Exception('Google Sign In Canceled');
          // throw FirebaseAuthException(code: "ERROR_ABORTED_BY_USER");
        }
        final GoogleSignInAuthentication googleAuth =
            await GUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }
      // Reauth with email and password
      else if (user.email != null) {
        String email = user.email!;
        String? password = await showPasswordDialog(context, email);
        if (password == null) {
          dismissLoadingIndicator(context);
          return;
        }
        credential =
            EmailAuthProvider.credential(email: email, password: password);
      } else {
        dismissLoadingIndicator(context);
        throw FirebaseAuthException(code: "UNKNOWN_PROVIDER");
      }
      await user.reauthenticateWithCredential(credential);
      dismissLoadingIndicator(context);
      await firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await auth.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RedirectingPage()),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully.")));
    } catch (e) {
      dismissLoadingIndicator(context);
      if (e.toString().contains('Google Sign In Canceled')) {
        return;
      } else if (e.toString().contains('We have blocked all requests')) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Actions blocked from this account, try again later.")));
        return;
      } else if (e.toString().contains(
          'supplied credentials do not correspond to the previously signed in user')) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("The choosen account is not correct."),
          backgroundColor: Colors.red,
        ));
        return;
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
        print('err ${e.toString()}');
        return;
      }
    }
  }

  // Show Password Dialog
  Future<String?> showPasswordDialog(BuildContext context, String email) async {
    String? errorText;
    final formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Please enter your password to confirm.",
                textAlign: TextAlign.center,
                style: textStyleWhite,
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'This action is permanent and cannot be undone. All your data will be permanently removed..',
                        textAlign: TextAlign.center),
                    buildInputField(
                        controller: passwordcontroller,
                        iconWidget: SvgPicture.asset(
                          'assets/svg/lock.svg',
                          width: 20,
                          height: 24,
                        ),
                        hintText: 'Enter your password',
                        obscureText: _obscureText,
                        togglePasswordView: _toggletoviewpassword),
                    TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: errorText,
                          // errorStyle: TextStyle(fontSize: 11),
                          border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              actions: [
                popUpBotton(
                  "Cancel",
                  AppColors.primaryText,
                  AppColors.buttonText,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                popUpBotton(
                  "Confirm",
                  AppColors.buttonColor,
                  AppColors.buttonText,
                  onPressed: () async {
                    String password = passwordcontroller.text.trim();
                    if (password.isEmpty) {
                      setState(() {
                        errorText = "Password can't be empty.";
                      });
                      return;
                    }
                    try {
                      AuthCredential credential = EmailAuthProvider.credential(
                          email: email, password: password);
                      await FirebaseAuth.instance.currentUser!
                          .reauthenticateWithCredential(credential);
                      Navigator.pop(context, password);
                    } catch (e) {
                      if (e
                          .toString()
                          .contains('We have blocked all requests')) {
                        setState(() {
                          errorText = "Request blocked, Try again later.";
                        });
                      } else {
                        setState(() {
                          errorText = "Incorrect password.";
                        });
                      }
                    }
                  },
                )
              ],
            );
          });
        });
  }
}
