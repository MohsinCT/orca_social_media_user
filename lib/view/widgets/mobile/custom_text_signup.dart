import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';

// ignore: must_be_immutable
class CustomTextSignup extends StatelessWidget {
  VoidCallback onPressed;
   CustomTextSignup({super.key , required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Don't have an Account?",
          style: TextStyle(fontSize: mediaQuery.screenWidth * 0.03),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Sign Up',
            style: TextStyle(
                color: AppColors.oRBlack,
                fontSize: mediaQuery.screenWidth * 0.03,
                fontWeight: FontWeight.bold
                // Responsive font size for text
                ),
          ),
        ),
      ],
    ); 
  }
}