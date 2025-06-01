import 'package:car_maintenance/AI-Chatbot/gemini.dart';
import 'package:car_maintenance/AI-Chatbot/send_message.dart';
import 'package:car_maintenance/AI-Chatbot/speech_to_text.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class Chatbot extends StatefulWidget {
  final String userId;
  const Chatbot({
    super.key,
    required this.userId,
  });

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
// Using ChatbotLogic
  late ChatLogic chatService;
  late SpeechToTextService speechService;
  SpeechToText _speech = SpeechToText();
  String? activeChatId;
  bool _isListening = false;
  final GeminiService _geminiService = GeminiService();
  TextEditingController messageController = TextEditingController();

  // Check if the reponse is in Arabic
  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  List<ChatMessage> messages = [];

  late ChatUser currentUser;
  ChatUser geminiBot = ChatUser(
      id: "bot",
      firstName: "Chatbot",
      profileImage: 'assets/images/chatbot_icon.png');

  void _sendMessage(ChatMessage ChatMsg) async {
    await chatService.sendMessage(
        chatMsg: ChatMsg,
        messages: messages,
        updateMessages: (updated) {
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

    print(
        "Loaded ${messagesList.length} messages for chat $chatId");
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

// NewChat Button function
  Future<void> createNewChat() async{
    setState(() {
      activeChatId = null;
      messages = [];
    });
    chatService.setActiveChatId(null);
    Navigator.of(context).pop();
  }
// Delete Chat 
  Future<void> deleteChat(String chatId) async{
    final chatRef = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('chats').doc(chatId);
    final messagesSnapshot = await chatRef.collection('messages').get();
    for(var doc in messagesSnapshot.docs){
      await doc.reference.delete();
    }
    await chatRef.delete();
    if (activeChatId == chatId){
      print('activeChatId is now null');
      setState(() {
        activeChatId = null;
        messages = [];
        messageController.clear();
      });
    }
    else{
      print('activeChatId is not null');
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    currentUser = ChatUser(
      id: user.uid,
      firstName: user.displayName,
      profileImage: user.photoURL,
    );
    chatService = ChatLogic(
        userId: currentUser.id,
        currentUser: currentUser,
        geminiBot: geminiBot,
        getGeminiRespone: _geminiService.getGeminiRespone);
    speechService = SpeechToTextService();
    speechService.initialize();
  }

  //voiceChat
  Future<void> _startSpeechToText() async {
    bool available = await _speech.initialize(onStatus: (status) {
      if (status == 'done' || status == 'notListening') {
        setState(() => _isListening = false);
      }
    }, onError: (error) {
      setState(() => _isListening = false);
    });

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            messageController.text = result.recognizedWords;
            messageController.selection = TextSelection.fromPosition(
                TextPosition(offset: messageController.text.length));
          });
        },
      );
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            centerTitle: true,
            title: const Text(
              'Chatbot',
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Inter',
              ),)
            ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Drawer(
            backgroundColor: AppColors.background,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
                    .collection('chats')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  return ListView(
                    children: [
                      DrawerHeader(
                        child: 
                      Text('History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildButton(
                          'New Chat', 
                          AppColors.secondaryText, 
                          AppColors.primaryText, 
                          onPressed: (){
                            createNewChat();
                          }),
                      ),
                      Divider(),
                      if (docs.isEmpty) 
                        const ListTile(
                          title: Text('No history yet'),
                          )
                      else 
                      ...docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final title = data['title'] ?? 'Untitled';
                        final chatId = doc.id;
                        return ListTile(
                          title: InkWell(
                            onTap: () {
                                print("Chat tapped: $chatId");
                                switchChat(chatId);
                              },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(title, overflow: TextOverflow.ellipsis,),
                                IconButton(
                                  onPressed: () async{
                                    bool confirmDelete = await showDialog(
                                      context: context, 
                                      builder: (_)=> AlertDialog(
                                        title: Text('Confirm Delete'),
                                        content: Text('Are you sure you want to delete this chat?\n This action can\'t be undone.'),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context, true);
                                            }, 
                                            child: Text('Confirm')),
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context, false);
                                            }, 
                                            child: Text('Cancel')),
                                        ],
                                      ));
                                      if(confirmDelete){
                                        await deleteChat(chatId);
                                        if(activeChatId == null){
                                        await createNewChat();
                                        }
                                      }
                                  }, 
                                  icon: SvgPicture.asset('assets/svg/delete.svg', width: 24, height: 24,),
                                  )
                              ],
                            ),
                          ),
                          
                        );
                      })
                    ],
                  );
                }),
          ),
        ),
        body:
        DashChat(
          currentUser: currentUser,
          onSend: (chatMsg) => _sendMessage(chatMsg),
          messages: messages,
          inputOptions: InputOptions(
              textController: messageController,
              trailing: [
                IconButton(
                    onPressed: () {
                      _isListening ? _stopListening() : _startSpeechToText();
                    },
                    icon: Icon(_isListening ? Icons.stop : Icons.mic)),
                    
              ],
              sendButtonBuilder: (onSend) {
                return IconButton(
                icon: Icon(Icons.send, color: AppColors.primaryText),
                onPressed: onSend,
                );
              },
              ),
          messageOptions: MessageOptions(
            showOtherUsersName: true,
            currentUserContainerColor: AppColors.primaryText,
            currentUserTextColor: Colors.white,
            messageTextBuilder: (message, previousMessage, nextMessage) {
              bool rtl = isArabic(message.text);
              final isBot = message.user.id == geminiBot.id;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                child: isBot
                    ? Directionality(
                        textDirection:
                            rtl ? TextDirection.rtl : TextDirection.ltr,
                        child: MarkdownBody(
                          selectable: true,
                          data: message.text,
                          styleSheet: MarkdownStyleSheet(
                              p: TextStyle(fontSize: 16),
                              h1: TextStyle(fontSize: 22),
                              h2: TextStyle(fontSize: 20),
                              h3: TextStyle(fontSize: 18),
                              a: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline)),
                          onTapLink: (text, href, title) async {
                            if (href != null) {
                              final uri = Uri.parse(href);
                              final launched = await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                              if (!launched) {
                                SnackBar(
                                  content: Text(
                                      'Error occured while opening the url'),
                                  backgroundColor: Colors.red,
                                );
                              }
                            }
                          },
                        ))
                    : Directionality(
                        textDirection:
                            rtl ? TextDirection.rtl : TextDirection.ltr,
                        child: SelectableText(
                          message.text,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
              );
            },
          ),
        ));
  }
}
