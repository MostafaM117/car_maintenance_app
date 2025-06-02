import 'package:car_maintenance/screens/Terms_and_conditionspage%20.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/custom_widgets.dart';

class UserSignupPage extends StatefulWidget {
  final VoidCallback showUserLoginPage;
  const UserSignupPage({super.key, required this.showUserLoginPage});
  @override
  State<UserSignupPage> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignupPage> {
  final _usernameController = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  bool _obscureText = true;
  final bool _isCheckingUsername = false;
  final String _usernameErrorText = '';
  bool _termschecked = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  bool confirmpassword() {
    if (_passwordcontroller.text.trim() ==
        _confirmpasswordcontroller.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserCredential?> signup() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).please_enter_username)));
      return null;
    } else if (!confirmpassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_passwords_not_match)),
      );
      return null;
    } else if (_emailcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An email address is required')),
      );
      return null;
    } else if (_passwordcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_enter_password)),
      );
      return null;
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailcontroller.text.trim(),
                password: _passwordcontroller.text.trim());

        await createuser(
          _usernameController.text.trim(),
          _emailcontroller.text.trim(),
          userCredential.user!.uid,
        );
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).registered_successfully),
            duration: Duration(milliseconds: 4000),
            backgroundColor: Colors.green.shade400,
          ),
        );
        return userCredential;
      } catch (e) {
        if (e.toString().contains('email-already-in-use')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).email_already_registered)),
          );
          return null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).error_generic + e.toString())),
          );
          return null;
        }
      }
    }
  }

  Future createuser(String username, String email, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'password': _passwordcontroller.text.trim(),
      'carAdded': false,
      'googleUser': false,
      'role': 'user',
    });
  }

  void _toggletoviewpassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              Text(
                S.of(context).Sigup_carPal,
                style: textStyleWhite.copyWith(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).welcome_back,
                style: textStyleGray.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              // // Username
              buildInputField(
                controller: _usernameController,
                iconWidget: SvgPicture.asset(
                  'assets/svg/user.svg',
                  width: 24,
                  height: 24,
                ),
                hintText: S.of(context).user_name,
                errorText: _usernameErrorText,
                suffixWidget: _isCheckingUsername
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),

              // Email address
              const SizedBox(height: 20),
              buildInputField(
                hintText: S.of(context).email,
                controller: _emailcontroller,
                iconWidget: SvgPicture.asset(
                  'assets/svg/inpox.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              //Password
              const SizedBox(height: 20),
              buildInputField(
                controller: _passwordcontroller,
                iconWidget: SvgPicture.asset(
                  'assets/svg/lock.svg',
                  width: 20,
                  height: 24,
                ),
                hintText: S.of(context).password,
                obscureText: _obscureText,
                togglePasswordView: _toggletoviewpassword,
              ),
              //Confirm Password
              const SizedBox(height: 20),
              buildInputField(
                controller: _confirmpasswordcontroller,
                iconWidget: SvgPicture.asset(
                  'assets/svg/lock.svg',
                  width: 20,
                  height: 24,
                ),
                hintText: S.of(context).confirm_password,
                obscureText: _obscureText,
              ),
              const SizedBox(height: 15),
              CheckboxListTile(
                  value: _termschecked,
                  title: RichText(
                      text: TextSpan(
                          style: textStyleGray.copyWith(fontSize: 12),
                          children: [
                        TextSpan(text: S.of(context).agree_terms_text),
                        TextSpan(
                            text: S.of(context).terms_and_privacy,
                            style: textStyleGray.copyWith(
                              color: Colors.blue.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              // decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsAndConditionsPage()));
                              })
                      ])),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (bool? value) {
                    setState(() {
                      _termschecked = value!;
                    });
                  }),
              const SizedBox(height: 60),
              // Signup Button requires terms to be checked
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    _termschecked
                        ? signup()
                        : SnackBar(
                            content: ScaffoldMessenger(
                                child: Text(
                            S.of(context).check_terms_warning,
                          )));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        _termschecked ? AppColors.buttonColor : Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).sign_up,
                          style: textStyleWhite.copyWith(
                              color: AppColors.buttonText))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              buildOrSeparator(context),
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    widget.showUserLoginPage();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: S.of(context).already_have_account,
                      style: textStyleWhite.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: S.of(context).sign_in,
                          style: textStyleWhite.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
