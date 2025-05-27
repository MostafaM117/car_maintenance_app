import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/complete_seller_info.dart';
// import 'package:flutter/gestures.dart';
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
  final _businessnameController = TextEditingController();
  final _businessemailcontroller = TextEditingController();
  final _nationalIdcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  bool _obscureText = true;
  final String _businessnameErrorText = '';
  bool _signupdatachecked = false;

  @override
  void dispose() {
    _businessnameController.dispose();
    _businessemailcontroller.dispose();
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

  void checkSignupdata() {
    final businessemail = _businessemailcontroller.text.trim();
    final businessname = _businessnameController.text.trim();
    final password = _passwordcontroller.text.trim();
    final nationalId = _nationalIdcontroller.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (businessname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a businessname')),
      );
    } else if (nationalId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your national id')),
      );
    } else if (nationalId.length != 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid national id')),
      );
    } else if (businessemail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An email address is required')),
      );
    } else if (!emailRegex.hasMatch(businessemail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a password to sign up')),
      );
    } else if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Your password should be at least 6 characters')),
      );
    } else if (!confirmpassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
    } else {
      setState(() {
        _signupdatachecked = true;
      });
    }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
            // Businessname
            buildInputField(
              controller: _businessnameController,
              iconWidget: SvgPicture.asset(
                'assets/svg/user.svg',
                width: 24,
                height: 24,
              ),
              hintText: 'Enter your business name',
              errorText: _businessnameErrorText,
            ),
            // National Id
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(right: 20),
              height: 45,
              decoration: ShapeDecoration(
                color: AppColors.secondaryText,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppColors.borderSide,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  const SizedBox(width: 20), //24
                  Icon(Icons.person_pin_outlined),
                  const SizedBox(width: 18), // 20
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(14),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _nationalIdcontroller,
                      decoration: InputDecoration(
                        hintText: 'Enter your national id number',
                        hintStyle: textStyleGray,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 12),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ],
              ),
            ),
            // Email address
            const SizedBox(height: 20),
            buildInputField(
              hintText: 'Enter your business email ',
              controller: _businessemailcontroller,
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
              hintText: 'Confirm your password',
              obscureText: _obscureText,
            ),
            const SizedBox(height: 40), //60
            buildButton('Sign up', AppColors.buttonColor, AppColors.buttonText,
                onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              checkSignupdata();
              _signupdatachecked
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompleteSellerInfo(
                                businessname:
                                    _businessnameController.text.trim(),
                                nationalID: _nationalIdcontroller.text.trim(),
                                businessemail:
                                    _businessemailcontroller.text.trim(),
                                password: _passwordcontroller.text.trim(),
                              )))
                  : print('Error Signing up');
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
    );
  }
}
