import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  // final userProvider = Provider.of<UserProvider>(context , listen:  false);
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: 'User');
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtOBrI5eTOg9nct4SXoNdYEq3fdqt0lnFY3EGNIwE--n-4V3ToQOra0MwLCn_z-K7b8UA&usqp=CAU");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(title: Text('Chat bot')),
        body: DashChat(
            currentUser: currentUser,
            onSend: _sendMessage,
            messages: messages));
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event){
        ChatMessage? lastMessage = messages.firstOrNull;
        if(lastMessage != null && lastMessage.user == geminiUser){
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold("", (previous, current) => "$previous${current.text}") ?? "";
          lastMessage.text = response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
         } else {
          String response = event.content?.parts?.fold("", (previous, current) => "$previous${current.toString()}") ?? "";
          ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text:response );

          setState(() {
            messages = [message, ...messages];
          });
         }
      });

      
    } catch (e) {
      log('Error sending messages $e');
    }
  }
}


