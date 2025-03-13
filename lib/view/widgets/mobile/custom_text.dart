import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final int count;
  final String text;
  const CustomText({super.key, required this.count, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Text(count.toString()),
            Text(text, style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      ],
    );
  }
}
