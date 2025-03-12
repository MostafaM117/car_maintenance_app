import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_widgets.dart';
import 'package:car_maintenance/screens/Auth/auth_service.dart';
import 'package:car_maintenance/services/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordView() {
    setState(() => _obscureText = !_obscureText);
  }

  Future<void> handleGoogleSignIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await AuthService().signInWithGoogle(context);
    } catch (e) {
      Navigator.of(context).pop();
      showErrorDialog(context, "Error during Google Sign-In: $e");
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 85),
              Text(
                'Sign in to appName',
                style: textStyleWhite.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome back! Please enter your details!',
                style: textStyleWhite.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 30),
              buildInputField(
                  controller: _emailController,
                  iconWidget:
                      Image.asset('assets/images/inbox 1.png', height: 24),
                  hintText: 'Enter your email or phone number'),
              const SizedBox(height: 20),
              buildInputField(
                  controller: _passwordController,
                  iconWidget:
                      Image.asset('assets/images/lock 1.png', height: 24),
                  hintText: 'Enter your password',
                  obscureText: _obscureText,
                  togglePasswordView: _togglePasswordView),
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
                    'Forget Password? Reset it',
                    style: textStyleWhite.copyWith(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              buildButton(
                  'Sign In', AppColors.buttonColor, AppColors.buttonText,
                  onPressed: () {
                AuthService().signInWithEmailAndPassword(
                  context,
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              }),
              const SizedBox(height: 15),
              buildOrSeparator(),
              const SizedBox(height: 15),
              googleButton(handleGoogleSignIn),
              const SizedBox(height: 15),
              appleButton(() {}),
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    widget.showRegisterPage();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: textStyleWhite.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: textStyleWhite.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
