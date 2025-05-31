import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/complete_seller_info.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/app_colors.dart';
import '../../../generated/l10n.dart';
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
        SnackBar(content: Text(S.of(context).error_enter_businessname)),
      );
    } else if (nationalId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_enter_national_id)),
      );
    } else if (nationalId.length != 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_invalid_national_id)),
      );
    } else if (businessemail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_enter_email)),
      );
    } else if (!emailRegex.hasMatch(businessemail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_invalid_email)),
      );
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_enter_password)),
      );
    } else if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).error_short_password)),
      );
    } else if (!confirmpassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_passwords_not_match)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                S.of(context).create_business_account,
                style: textStyleWhite.copyWith(fontSize: 24),
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
              // Businessname
              buildInputField(
                controller: _businessnameController,
                iconWidget: SvgPicture.asset(
                  'assets/svg/user.svg',
                  width: 24,
                  height: 24,
                ),
                hintText: S.of(context).enter_business_name,
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
                          hintText: S.of(context).enter_national_id,
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
                hintText: S.of(context).emailS,
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
                hintText:S.of(context).confirm_password,
                obscureText: _obscureText,
              ),
              const SizedBox(height: 40), //60
              buildButton(S.of(context).sign_up, AppColors.buttonColor,
                  AppColors.buttonText, onPressed: () {
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

              buildOrSeparator(context),
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    widget.showSellerLoginPage();
                  },
                  child: Text.rich(
                    TextSpan(
                      text:S.of(context).already_have_account,
                      style: textStyleWhite.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: S.of(context).sign_in,
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
