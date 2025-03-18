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
  final _usernameController = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  bool _obscureText = true;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = true;
  String _usernameErrorText = '';

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


  Future<bool> isUsernameUnique(String username) async {
    setState(() {
      _isCheckingUsername = true;
      _isUsernameAvailable = true;
      _usernameErrorText = '';
    });
    
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = querySnapshot.docs.isEmpty;
        if (!_isUsernameAvailable) {
          _usernameErrorText = 'Username is already taken';
        }
      });
      
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      setState(() {
        _isCheckingUsername = false;
        _usernameErrorText = 'Error checking username';
      });
      return false;
    }
  }

  Future signup() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username')),
      );
      return;
    }
    
    final isUnique = await isUsernameUnique(_usernameController.text.trim());
    if (!isUnique) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username is already taken, try another one')),
      );
      return;
    }
    
    if (!confirmpassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (_emailcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An email address is required')),
      );
      return;
    }
    if (_passwordcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a password to sign up')),
      );
      return;
    }
    
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());
      
      await createuser(
        _usernameController.text.trim(),
        _emailcontroller.text.trim(),
        userCredential.user!.uid,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registred Successfully, Complete Your First time setup'), 
          duration:Duration(milliseconds: 4000),
          backgroundColor: Colors.green.shade400,
          ),
      );
      ;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future createuser(String username, String email, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'password': _passwordcontroller.text.trim(),
      'carAdded': false,
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
              
              // Username
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: _usernameErrorText.isNotEmpty ? _usernameErrorText : null,
                    suffixIcon: _isCheckingUsername 
                      ? Container(
                          width: 20,
                          height: 20,
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ) 
                      : null,
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _usernameController,
                  onChanged: (value) {
                    if (value.length > 3) {
                      isUsernameUnique(value);
                    }
                  },
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
