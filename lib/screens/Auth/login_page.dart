import 'package:car_maintenance/screens/Auth/auth_service.dart';
import 'package:car_maintenance/services/forgot_password.dart';
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


  void _toggletoviewpassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> handleGoogleSignIn() async{
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context){
        return Center(
          child: CircularProgressIndicator(),
        );
      });
      try{
      await AuthService().signInWithGoogle(context);
      } catch(e){
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
                      AuthService().signInWithEmailAndPassword(
                        context,
                        _emailcontroller.text.trim(),
                        _passwordcontroller.text.trim(),
                      );
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
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 8),
                child: const SizedBox(
                  // width: 30,
                  child: Text("Login with",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: handleGoogleSignIn
                      // () {AuthService().signInWithGoogle(context);}
                        ,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Image.asset("assets/Google_logo.png"),
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const SizedBox(
                  // width: 30,
                  child: Text("or",style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Image.asset("assets/apple_logo.png"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
