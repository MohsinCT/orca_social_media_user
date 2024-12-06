import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';

// ignore: must_be_immutable
class CustonTextLogin extends StatelessWidget {
  VoidCallback onPressed;
  CustonTextLogin({super.key , required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(fontSize: mediaQuery.screenWidth * 0.03),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Log in',
            style: TextStyle(
                color: AppColors.oRloginblue,
                fontSize: mediaQuery.screenWidth * 0.03
                // Responsive font size for text
                ),
          ),
        ),
      ],
    );
  }
}
