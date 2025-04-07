import 'package:car_maintenance/services/delete_account.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                        DeleteAccount().deleteAccount(context) ;
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