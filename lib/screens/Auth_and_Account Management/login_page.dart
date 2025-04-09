import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignupPage;
  const LoginPage({super.key, required this.showSignupPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool _obscureText = true;

  void _toggletoviewpassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> handleGoogleSignIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await AuthService().signInWithGoogle(context);
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
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
                'Sign in to Motorgy',
                style: textStyleWhite.copyWith(fontSize: 24,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome back! Please enter your details!',
                style: textStyleGray.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              buildInputField(
                  controller: _emailcontroller,
                  iconWidget: SvgPicture.asset(
                    'assets/svg/inpox.svg',
                    width: 24,
                    height: 24,
                  ),
                  hintText: 'Enter your email '),
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
                  togglePasswordView: _toggletoviewpassword),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ),
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: textStyleWhite.copyWith(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              buildButton(
                  'Sign In', AppColors.buttonColor, AppColors.buttonText,
                  onPressed: () {
                AuthService().signInWithEmailAndPassword(
                  context,
                  _emailcontroller.text.trim(),
                  _passwordcontroller.text.trim(),
                );
              }),
              const SizedBox(height: 15),
              buildOrSeparator(),
              const SizedBox(height: 15),
              googleButton(handleGoogleSignIn),
              const SizedBox(height: 15),
              // appleButton(() {}),
              // const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    widget.showSignupPage();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: textStyleWhite.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: textStyleWhite.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
