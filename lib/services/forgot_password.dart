import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailcontroller = TextEditingController();
  
  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Future<void>checkEmailforPasswordReset(String email, BuildContext context) async{
    final String email = _emailcontroller.text.trim();
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('Password reset email sent successfully'),
        backgroundColor: Colors.green,),
      );
    //   final querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
    
    // if(querySnapshot.docs.isNotEmpty){
    //   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Password reset email sent successfully')),
    //   );
    // }else{
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('No user found, Please enter a valid email')),
    //   );
    // }
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send password reset email, error: $e')),
    );
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('forgot password',
        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold, color: Colors.black),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text("Please enter your email and we will send you a password reset link.",
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 30,),
              TextField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: 'Please enter your email',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
              const SizedBox(height: 30,),
              ElevatedButton(
                    onPressed: (){
                      final email = _emailcontroller.text.trim();
                      if(email.isNotEmpty){
                      checkEmailforPasswordReset(email, context);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter an email')),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                    side: const BorderSide(
                      width: 0.2,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  ), child: const Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 20),)
                  ),
            ],
          ),
        ),
      ),
    );
  }
}