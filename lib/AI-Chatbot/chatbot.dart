import 'package:car_maintenance/AI-Chatbot/gemini.dart';
import 'package:car_maintenance/services/user_data_helper.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final GeminiService _geminiService = GeminiService();

  final user = FirebaseAuth.instance.currentUser;
  String? username;
  List <ChatMessage> messages = [];
  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }
  ChatUser currentUser = ChatUser(id: "0", firstName: "Mostafa");
  ChatUser geminiBot = ChatUser(
    id: "1", 
    firstName: "Gemini",
    profileImage: 'assets/images/Gemini_icon.png'
    );

  // Logic for Sending messages 
  void _sendMessage(ChatMessage ChatMsg) async{
    setState(() {
      messages = [ChatMsg, ...messages];
    });
    try{
      String userQuestion = ChatMsg.text;
      final responseText = await _geminiService.getGeminiRespone(userQuestion);
      final botMsg = ChatMessage(user: geminiBot, text: responseText , createdAt: DateTime.now());
    setState(() {
      messages = [botMsg, ...messages];
    });
    }
    catch(e){
      print(e);
    }
  }
  // Chat UI
  Widget _BuildUI(){
    return DashChat(currentUser: currentUser, onSend: _sendMessage, messages: messages);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chatbot')
        ),
      body: _BuildUI(),
    );
  }
}