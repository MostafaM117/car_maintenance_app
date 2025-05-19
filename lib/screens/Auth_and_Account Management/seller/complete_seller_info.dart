import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Terms_and_conditionspage%20.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompleteSellerInfo extends StatefulWidget {
  final String businessname;
  final String businessemail;
  final String password;
  final String nationalId;

  const CompleteSellerInfo({
    super.key, 
    required this.businessname, 
    required this.businessemail,
    required this.password,
    required this.nationalId,
    });

  @override
  State<CompleteSellerInfo> createState() => _CompleteSellerInfoState();
}

class _CompleteSellerInfoState extends State<CompleteSellerInfo> {

  final _taxsnumbercontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  bool _termschecked = false;
  bool _isLoading = false;

  //Finish Signing up Function
  Future<UserCredential?> finishSignup() async {
    if (_taxsnumbercontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your tax registration number')),
      );
      return null;
    }
    else if (_phonenumbercontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your phone number')),
      );
      return null;
    }
    else {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: widget.businessemail,
                password: widget.password);

        await createuser(
          widget.businessname,
          widget.businessemail,
          widget.nationalId,
          userCredential.user!.uid,
        );
        Navigator.pop(context);
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
        if (e.toString().contains('email-already-in-use')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This email is already registered')),
          );
          return null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
          return null;
        }
      }
      finally {
        // Hide loader
        if (mounted) {
        setState(() {
          _isLoading = false;
        });
        }
      }
    }
  }

  Future createuser(String businessname, String email, String nationalId, String uid) async {
    await FirebaseFirestore.instance.collection('sellers').doc(uid).set({
      'business_name': businessname,
      'email': email,
      'National_ID': nationalId,
      'uid': uid,
      'tax_registration_number': _taxsnumbercontroller.text.trim(),
      'phone_number': _phonenumbercontroller.text.trim(),
      // 'password': _passwordcontroller.text.trim(),
      'role': 'seller',
      'googleUser': false,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading ? Center(child: CircularProgressIndicator()) 
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              Text(
                'Complete your business account details',
                style: textStyleGray.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              // Tax Registration Number 
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
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _taxsnumbercontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter your tax registration number',
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
              SizedBox(height: 20,),
              // Phone number
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
                    Icon(Icons.phone),
                    const SizedBox(width: 18), // 20
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _phonenumbercontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter your business phone number',
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
              // Location logic will be here 
              // Uploading image logic will be here 
              const SizedBox(height: 15),
              CheckboxListTile(
                  value: _termschecked,
                  title: RichText(
                      text: TextSpan(
                          style: textStyleGray.copyWith(fontSize: 12),
                          children: [
                        const TextSpan(
                            text: 'By signing up, you agree to our '),
                        TextSpan(
                            text: 'Terms of Service and privacy Policy.',
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
              const SizedBox(height: 30), //60
              // Signup Button requires terms to be checked
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    _termschecked
                        ? finishSignup()
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Terms of Service must be checked'),),
                                );
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
                      Text('Finish Signing up',
                          style: textStyleWhite.copyWith(
                              color: AppColors.buttonText))
                    ],
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