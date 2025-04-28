import 'package:car_maintenance/AI-Chatbot/gemini.dart';
import 'package:car_maintenance/AI-Chatbot/send_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Chatbot extends StatefulWidget {
  final String userId;
  const Chatbot({super.key, required this.userId,});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
// Using ChatbotLogic
  late ChatLogic chatService;
  String? activeChatId;
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
  //////
  // ChatUser currentUser = ChatUser(id: "0", firstName: "Mostafa");
  late ChatUser currentUser;
  ChatUser geminiBot = ChatUser(
    id: "bot", 
    firstName: "Chatbot",
    profileImage: 'assets/images/chatbot_icon.png'
    );

    // Logic for Sending messages 
  // void _sendMessage(ChatMessage ChatMsg) async{
  //   final loadingMessage = ChatMessage(
  //   user: geminiBot,
  //   text: 'loading..',
  //   createdAt: DateTime.now(),
  // );
  //   setState(() {
  //     messages = [ChatMsg, ...messages];
  //     messages.insert(0, loadingMessage);
  //   });
  //   try{
  //     String userQuestion = ChatMsg.text;
  //     final responseText = await _geminiService.getGeminiRespone(userQuestion);
  //     final botMsg = ChatMessage(user: geminiBot, text: responseText , createdAt: DateTime.now());
  //   setState(() {
  //     messages = [botMsg, ...messages];
  //     messages.remove(loadingMessage);
  //   });
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }

  void _sendMessage(ChatMessage ChatMsg) async {
    await chatService.sendMessage(chatMsg: ChatMsg, messages: messages, updateMessages: (updated){
      setState(() {
        messages = updated;
      });
    });
  }

  //loadMessages
Future<List<ChatMessage>> loadMessagesFromFirestore(String chatId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userId)
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .get();

  List<ChatMessage> messagesList = querySnapshot.docs.map((doc) {
    final data = doc.data();
    return ChatMessage(
      user: data['userId'] == currentUser.id ? currentUser : geminiBot,
      text: data['text'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }).toList();

  print("Loaded ${messagesList.length} messages for chat $chatId"); // Debugging print
  return messagesList;
}

// switchChat
void switchChat(String newChatId) async {
    final newMessages = await loadMessagesFromFirestore(newChatId);
    setState(() {
      activeChatId = newChatId;
      messages = newMessages;
    });
    chatService.setActiveChatId(newChatId);
    Navigator.of(context).pop();
  }

// NewChat
void createNewChat() {
  setState(() {
    activeChatId = null;
    messages = [];
  });
  chatService.setActiveChatId(null);
  Navigator.of(context).pop(); // close the drawer
}

//voiceChat 
// bool _isListening = false;
// void _listen() async{
//   if(!_isListening){
//     bool available = await SpeechToText.initialize();
//     if(available){
//       setState(() {
//         _isListening = true;
//         SpeechToText.listenMethod(onResult)
//       });
//     }

//   }
// }
  @override
  void initState(){
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    currentUser = ChatUser(
      id: user.uid,
      firstName: user.displayName,
      profileImage: user.photoURL,
    );
    chatService = ChatLogic(userId: currentUser.id, currentUser: currentUser, geminiBot: geminiBot, getGeminiRespone: _geminiService.getGeminiRespone);
    // speechService = SpeechToTextService();
    // speechService.initialize();
  }
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              );
          }
        ),
        centerTitle: true,
        title: const Text('Chatbot')
        ),
        drawer: Drawer(
          child: StreamBuilder<QuerySnapshot>(
            stream: 
            FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('chats').orderBy('createdAt', descending: true).snapshots(), 
            builder: (context, snapshot){
              if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
              }
              final docs = snapshot.data!.docs;
              if(docs.isEmpty){
              return Text('No Chats');
              }
              return ListView(
                children: [
                  DrawerHeader(child: Text('past chats')),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('New Chat'),
                    onTap: () {
                      createNewChat();
                    },
                  ),
                  Divider(),
                  ...docs.map((doc){
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title'] ?? 'Untitled';
                    final chatId = doc.id;
                    return ListTile(
                      title: Text(title),
                      onTap: () {
                        print("Chat tapped: $chatId");
                        switchChat(chatId);
                      },
                    );
                  })
                ],
              );
            }),
        ),
      body: DashChat(
      currentUser: currentUser, 
      onSend: (chatMsg)=> _sendMessage(chatMsg), 
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
              ),
          );
        },
      ),
      )
    );
  }
}