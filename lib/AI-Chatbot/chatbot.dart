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

  // Check if the reponse is in Arabic
  bool isArabic (String text){
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
  // Parsing Response 
  List<TextSpan> _parseResponse (String response){
  final List<TextSpan> formattedText = [];
  final lines = response.split('\n');
  for(var line in lines){
    if(line.trim().startsWith('*')){
      final cleanedline = line.trim().substring(1).trim();
      final boldRegex = RegExp(r'\*\*(.*?)\*\*');
      final match = boldRegex.firstMatch(cleanedline);
      if(match != null){
        final boldText = match.group(1)!;
        final restText = cleanedline.replaceAll(match.group(0)!, '').trim();

      formattedText.add(
        TextSpan(
        text: '• ',
      )
      );
      formattedText.add(
        TextSpan(
        text: '$boldText\n',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      )
      );
      formattedText.add(
        TextSpan(
        text: '$restText\n',
        style: TextStyle(fontSize: 16)
      )
      );
      }
    }
    else{
      formattedText.add(
        TextSpan(
          text: '$line\n',
          style: TextStyle(fontSize: 16)
        ));
    }
  }
    return formattedText;
}
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
      RichText(
        text: TextSpan(
        children: _parseResponse(botMsg.text)
      ));
    setState(() {
      messages = [botMsg, ...messages];
    });
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chatbot')
        ),
      body: DashChat(
      currentUser: currentUser, 
      onSend: _sendMessage, 
      messages: messages,
      messageOptions: MessageOptions(
        showOtherUsersName: true,
        messageTextBuilder:(message, previousMessage, nextMessage) {
          bool rtl = isArabic(message.text);
          final isBot = message.user.id == geminiBot.id;
          return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            child: isBot ? 
            Directionality(
              textDirection: rtl? TextDirection.rtl : TextDirection.ltr, 
              child: 
            SelectableText.rich(
              TextSpan(
              children: _parseResponse(message.text),
              style: TextStyle(
                // fontSize: 14,
                color: Colors.black
              )
            )
            )
              )
            : 
            Directionality(
              textDirection: rtl? TextDirection.rtl : TextDirection.ltr, 
              child: 
            SelectableText(
              message.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
                ),)
              )
          );
        },
      ),
      )
    );
  }
}