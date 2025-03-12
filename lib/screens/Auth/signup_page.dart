import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({super.key, required this.showLoginPage});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstnamecontroller = TextEditingController();
  final _lastnamecontroller = TextEditingController();
  final _agecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _firstnamecontroller.dispose();
    _lastnamecontroller.dispose();
    _agecontroller.dispose();
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

  Future signup() async {
    if (confirmpassword()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());
    }
    createuser(
      _firstnamecontroller.text.trim(),
      _lastnamecontroller.text.trim(),
      int.parse(_agecontroller.text.trim()),
      _emailcontroller.text.trim(),
      _passwordcontroller.text.trim(),
    );
  }

  Future createuser(String firstname, String lastname, int age, String email,
      String password) async {
    await FirebaseFirestore.instance.collection('users').add({
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'email': email,
      'password': password
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80.0,
              ),
              const Text(
                "Sign up with your details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 16.0),
              // First Name
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _firstnamecontroller,
                ),
              ),
              // Last Name
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _lastnamecontroller,
                ),
              ),
              // Age
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  controller: _agecontroller,
                ),
              ),
              // Email address
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _emailcontroller,
                ),
              ),
              //Password
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          _toggletoviewpassword();
                        },
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _passwordcontroller,
                ),
              ),
              //Confirm Password
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _confirmpasswordcontroller,
                ),
              ),
              SizedBox(
                width: 180,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    signup();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Register now",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const SizedBox(
                child: Text(
                  "or",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                    onPressed: () {
                      widget.showLoginPage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
