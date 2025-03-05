import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/AI-Chatbot/chatbot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Signed in as ${user.email}"),
          ],
        ),
      ),
     floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Chatbot()),
          );
        },
        label: const Text('Chatbot'),
        icon: const Icon(Icons.chat),
        backgroundColor: Color(0xFFD1A3FF), // Light purple
      ),
    );
  }
}
