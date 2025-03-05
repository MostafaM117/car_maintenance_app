import 'package:car_maintenance/services/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool _obscureText = true;

  Future signIn() async {
    final String email = _emailcontroller.text.trim();
    final String password = _passwordcontroller.text.trim();
    // await FirebaseAuth.instance.
    // signInWithEmailAndPassword(email: _emailcontroller.text.trim(), password: _passwordcontroller.text.trim());
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An email address is required')),
      );
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your password')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logged in successfully'),
        backgroundColor: Colors.green,
      ));
    } on FirebaseAuthException catch (e) {
      print('Error code : ${e.code}');
      if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'This device is temporarily blocked due to too many failed login attempts, try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found with this email'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect email or Password'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid email address'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 250.0,
              ),
              const Text(
                "Hello There",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Email address',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  controller: _emailcontroller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _passwordcontroller,
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ));
                      },
                      child: const Text(
                        "forgot password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 160,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
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
                    widget.showRegisterPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
