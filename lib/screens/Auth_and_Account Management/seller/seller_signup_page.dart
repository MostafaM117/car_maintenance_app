import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/custom_widgets.dart';

class SellerSignupPage extends StatefulWidget {
  final VoidCallback showSellerLoginPage;
  const SellerSignupPage({super.key, required this.showSellerLoginPage});
  @override
  State<SellerSignupPage> createState() => _SellerSignupPageState();
}

class _SellerSignupPageState extends State<SellerSignupPage> {
  final _ShopnameController = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  bool _obscureText = true;
  final bool _isCheckingUsername = false;
  final String _ShopnameErrorText = '';

  @override
  void dispose() {
    _ShopnameController.dispose();
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

  Future <UserCredential?> signup() async {
    if (_ShopnameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username')),
      );
      // return null;
    }

    else if (!confirmpassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      // return;
    }
    else if (_emailcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An email address is required')),
      );
      // return;
    }
    else if (_passwordcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a password to sign up')),
      );
      // return;
    }
    else {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailcontroller.text.trim(),
              password: _passwordcontroller.text.trim());

      await createuser(
        _ShopnameController.text.trim(),
        _emailcontroller.text.trim(),
        userCredential.user!.uid,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Registred Successfully, Complete Your First time setup'),
          duration: Duration(milliseconds: 4000),
          backgroundColor: Colors.green.shade400,
        ),
      );
      return userCredential;
    } catch (e) {
      if(e.toString().contains('email-already-in-use')){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This email is already registered')),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      }
    }
  }
    }

  Future createuser(String shopname, String email, String uid) async {
    await FirebaseFirestore.instance.collection('sellers').doc(uid).set({
      'shopname': shopname,
      'email': email,
      'uid': uid,
      'password': _passwordcontroller.text.trim(),
      'role': 'seller',
      'googleUser': false,
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
                'Create your business account now',
                style: textStyleWhite.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome! Please enter your details!',
                style: textStyleGray.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              // // Username
              buildInputField(
                controller: _ShopnameController,
                iconWidget: SvgPicture.asset(
                  'assets/svg/user.svg',
                  width: 24,
                  height: 24,
                ),
                hintText: 'Enter your Shopname',
                errorText: _ShopnameErrorText,
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
                hintText: 'Enter your business email ',
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
                hintText: 'Enter your password',
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
                hintText: 'Confirm Password',
                obscureText: _obscureText,
              ),
              const SizedBox(height: 15),
              Text(
                'By signing up, You agree to our Terms of Service and privacy Policy',
                style: textStyleGray
              ),
              const SizedBox(height: 60),

              buildButton(
                  'Sign up', AppColors.buttonColor, AppColors.buttonText,
                  onPressed: () {
                signup();
              }),
              const SizedBox(height: 10),

              buildOrSeparator(),
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    widget.showSellerLoginPage();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an accoun? ',
                      style: textStyleWhite.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: textStyleWhite.copyWith(
                            fontSize: 12,
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
