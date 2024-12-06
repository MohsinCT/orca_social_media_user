import 'package:flutter/material.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text('Chat bot'),
    ),
    body: Center(
      child: Text('API Gemini '),
    ),
    );
  }
}