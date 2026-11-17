import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:orca_social_media/models/messages_model.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final Gemini gemini = Gemini.instance;
  final TextEditingController _textController = TextEditingController();

  List<ChatMessage> messages = [];

  final ChatUser currentUser = const ChatUser(id: "0", firstName: 'User');
  final ChatUser geminiUser = const ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtOBrI5eTOg9nct4SXoNdYEq3fdqt0lnFY3EGNIwE--n-4V3ToQOra0MwLCn_z-K7b8UA&usqp=CAU",
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: Text('Chat bot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.user.id == currentUser.id;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Write a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isEmpty) return;
                      _textController.clear();
                      _sendMessage(
                        ChatMessage(
                          user: currentUser,
                          createdAt: DateTime.now(),
                          text: text,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      final String question = chatMessage.text;
      gemini.promptStream(parts: [Part.text(question)]).listen((event) {
        final String chunk = event?.output ?? '';
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user.id == geminiUser.id) {
          lastMessage = messages.removeAt(0);
          lastMessage.text = '${lastMessage.text}$chunk';
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          final ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: chunk,
          );
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


