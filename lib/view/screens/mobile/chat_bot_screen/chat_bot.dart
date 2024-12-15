import 'package:flutter/material.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: CustomAppbar(title: Text('Chat bot')),
    body: Center(
      child: Text('API Gemini '),
    ),
    );
  }
}