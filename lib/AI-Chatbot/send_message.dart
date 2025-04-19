import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatLogic {
  final String userId;
  final ChatUser currentUser;
  final ChatUser geminiBot;
  final Future <String> Function(String) getGeminiRespone;
  String? activeChatId;

  ChatLogic({
    required this.userId,
    required this.currentUser,
    required this.geminiBot,
    required this.getGeminiRespone,
  });

  Future <void> sendMessage({
    required ChatMessage chatMsg,
    required List<ChatMessage> messages,
    required Function(List<ChatMessage>) updateMessages,
  }) async{
    final isNewChat = activeChatId == null;
    final loadingMessage = ChatMessage(
    user: geminiBot,
    text: 'loading..',
    createdAt: DateTime.now(),
  );

  // Add Messages
  updateMessages([loadingMessage, chatMsg, ...messages]);
  try{
    // New Chat Creation in Firebase
    if (isNewChat){
      final chatDoc = await FirebaseFirestore.instance.collection('users').doc(userId).collection('chats').add({
        'title': chatMsg.text.length > 30 ? 
        chatMsg.text.substring(0, 30) + '...'
        : chatMsg.text,
        'createdAt': DateTime.now(),
      });
      activeChatId = chatDoc.id;
    }
    final chatRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('chats').doc(activeChatId);

    await chatRef.collection('messages').add({
      'text': chatMsg.text,
      'userId': chatMsg.user.id,
      'createdAt': DateTime.now(),
    });

    final responseText = await getGeminiRespone(chatMsg.text);
    final botMsg = ChatMessage(user: geminiBot, text: responseText , createdAt: DateTime.now());

    await chatRef.collection('messages').add({
      'text': botMsg.text,
      'userId': botMsg.user.id,
      'createdAt': botMsg.createdAt,
    });

    //update messages with bot Response
    final updatedMessages = [botMsg, chatMsg, ...messages.where((m) => m!= loadingMessage),
    ];
    updateMessages(updatedMessages);
  }
  catch (e){
    print('Error in ChatLogic: $e');
  }
  }
}