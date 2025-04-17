import 'package:car_maintenance/AI-Chatbot/gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List <ChatMessage> messages = [];

  // Get Current Username from Database
  // final user = FirebaseAuth.instance.currentUser;
  // String? username;
  // void loadUsername() async {
  //   String? fetchedUsername = await getUsername();
  //   setState(() {
  //     username = fetchedUsername;
  //   });
  // }
  ChatUser currentUser = ChatUser(id: "0", firstName: "Mostafa");
  ChatUser geminiBot = ChatUser(
    id: "1", 
    firstName: "Chatbot",
    profileImage: 'assets/images/chatbot_icon.png'
    );

  // Logic for Sending messages 
  void _sendMessage(ChatMessage ChatMsg) async{
    final loadingMessage = ChatMessage(
    user: geminiBot,
    text: 'loading..',
    createdAt: DateTime.now(),
  );
    setState(() {
      messages = [ChatMsg, ...messages];
      messages.insert(0, loadingMessage);
    });
    try{
      String userQuestion = ChatMsg.text;
      final responseText = await _geminiService.getGeminiRespone(userQuestion);
      final botMsg = ChatMessage(user: geminiBot, text: responseText , createdAt: DateTime.now());
    setState(() {
      messages = [botMsg, ...messages];
      messages.remove(loadingMessage);
    });
    }
    catch(e){
      print(e);
    }
  }
  // UI
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
              child: MarkdownBody(
                selectable: true,
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 16),
                  h1: TextStyle(fontSize: 22),
                  h2: TextStyle(fontSize: 20),
                  h3: TextStyle(fontSize: 18),
                  a: TextStyle(fontSize: 16, decoration: TextDecoration.underline)
                ),
                onTapLink: (text, href, title) async {
                if (href != null) {
                  final uri = Uri.parse(href);
                  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                  if(!launched) {
                  SnackBar(content: Text('Error occured while opening the url'), backgroundColor: Colors.red,);
                  }
                }
                },
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