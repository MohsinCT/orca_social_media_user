import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';

class SStoryCircle extends StatelessWidget {
  const SStoryCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return SizedBox(
      height: mediaQuery.screenHeight * 0.15,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(),
            width: 100,
            height: 100,
          );
        },
      ),
    );
  }
}
