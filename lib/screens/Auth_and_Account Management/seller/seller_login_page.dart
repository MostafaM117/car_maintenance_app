import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/custom_widgets.dart';

class SellerLoginPage extends StatefulWidget {
  final VoidCallback showSellerSignupPage;
  const SellerLoginPage({super.key, required this.showSellerSignupPage});

  @override
  State<SellerLoginPage> createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
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
      await AuthService().signInWithGoogle(context, role: 'seller');
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.welcomeBack("User"),
                style: textStyleWhite.copyWith(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.sellerLoginWelcome,
                style: textStyleGray,
              ),
              const SizedBox(height: 30),
              buildInputField(
                  controller: _emailcontroller,
                  iconWidget: SvgPicture.asset(
                    'assets/svg/inpox.svg',
                    width: 24,
                    height: 24,
                  ),
                  hintText: l10n.emailHint),
              const SizedBox(height: 20),
              buildInputField(
                  controller: _passwordcontroller,
                  iconWidget: SvgPicture.asset(
                    'assets/svg/lock.svg',
                    width: 20,
                    height: 24,
                  ),
                  hintText: l10n.passwordHint,
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
                    l10n.forgotPassword,
                    style: textStyleWhite.copyWith(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              buildButton(
                  l10n.login, AppColors.buttonColor, AppColors.buttonText,
                  onPressed: () {
                AuthService().signInWithEmailAndPassword(
                    context,
                    _emailcontroller.text.trim(),
                    _passwordcontroller.text.trim(),
                    'seller');
              }),
              const SizedBox(height: 15),
              buildOrSeparator(context),
              const SizedBox(height: 15),
              googleButton(handleGoogleSignIn, context),
              const SizedBox(height: 15),
              // appleButton(() {}),
              // const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    widget.showSellerSignupPage();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: '${l10n.noAccount} ',
                      style: textStyleWhite.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: l10n.register,
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
