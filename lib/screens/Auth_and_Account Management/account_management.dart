import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  final _usernameEditcontroller = TextEditingController();
  bool _isediting = false;
  User? _user = FirebaseAuth.instance.currentUser;

 //Get current username
  Future<void> _getcurrentusername() async {
    if(_user != null){
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (userDoc.exists){
      setState(() {
      _usernameEditcontroller.text = userDoc['username']?? '';
      });
      }
    }
  }
  //Update current username
  Future<void> _updateUsername() async {
    if(_user == null){ return; }
    String newUsername = _usernameEditcontroller.text.trim();
    if(newUsername.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username cannot be empty'), backgroundColor: Colors.red,),
      );
      return;
    } 
      await FirebaseFirestore.instance
      .collection('users')
      .doc(_user!.uid)
      .update({'username': newUsername});
  }
  // Press edit username to edit
  void _toggleEdit() {
    setState(() {
      _isediting = !_isediting; 
    });
  }
  // Delete Account 
  Future <void> _deleteAccount(BuildContext context) async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    if(user == null){ 
      return;
      }
    try{
      AuthCredential credential;
      //Reauth
      if(user.providerData.any((info)=> info.providerId == "google.com")){
        //Google Reauth
        final GoogleSignIn Gsignin = GoogleSignIn();
        final GoogleSignInAccount? GUser = await Gsignin.signIn();
        if(GUser == null){
          throw FirebaseAuthException(code: "ERROR_ABORTED_BY_USER");
        }
        final GoogleSignInAuthentication googleAuth = await GUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else if(user.email != null){
        String email = user.email!;
        String? password = await showPasswordDialog(context);
        if(password == null) return;
        credential = EmailAuthProvider.credential(email: email, password: password);
      }
      else{
        throw FirebaseAuthException(code: "UNKNOWN_PROVIDER");
      }
      await user.reauthenticateWithCredential(credential);
      await firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await auth.signOut();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> RedirectingPage()), (route)=> false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account deleted successfully.")));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
  // Show Password Dialog
  Future<String?> showPasswordDialog(BuildContext context) async {
    TextEditingController passwordcontroller = TextEditingController();
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Please Enter Your Password"),
          content: TextField(
            controller: passwordcontroller,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"), 
              onPressed: (){
                Navigator.pop(context);
              },),
              TextButton(child: Text("Confirm"),
              onPressed: (){
                Navigator.pop(context, passwordcontroller.text);
              },)
          ],
          );
      });
  }
  @override
  void initState() {
    super.initState();
    _getcurrentusername();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Management'),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_sharp)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                enabled: _isediting,
                decoration: InputDecoration(
                  prefixStyle: TextStyle(fontSize: 18, color: _isediting? Colors.black : Colors.grey , fontWeight: FontWeight.bold),
                  prefixText: 'username: ',
                  border: _isediting ?  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),) :
                    OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: _usernameEditcontroller,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isediting ? Colors.green.shade400 : Colors.red.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    _isediting ? "Update username" : "Edit username", 
                    style: textStyleWhite.copyWith(color: Colors.white)),
                  ],
                  ),
                onPressed: () {
                  if(_usernameEditcontroller.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Username can\'t be empty'), backgroundColor: Colors.red,),
                  );
                  }
                  else{
                  _toggleEdit();
                  _updateUsername();
                  _isediting ? ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Now you can edit your username'), duration: Duration(milliseconds: 1000),),
                  )
                  : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Username updated successfully'), duration: Duration(milliseconds: 1000),backgroundColor: Colors.green.shade400,),
                  );
                  }
                }
              ),
            ),
            SizedBox(
              height: 30,
            ),
            buildButton(
              'Edit Password', Colors.red.shade700, Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
              }
            ),
            SizedBox(
              height: 30,
            ),
            buildButton(
              'Delete My Account', Colors.red.shade700, Colors.white,
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Delete Account'),
                    content: Text('Are you sure you want to delete your account? \nThis action will delete the account totally and will remove all related data.'),
                    actions: [
                      TextButton(onPressed: () {
                        _deleteAccount(context);
                      },
                      child: Text("Yes"),),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text('Cancel'))
                    ],
                  );
                });
              }
            ),
          ],
        ),
      ),
    );
  }
}