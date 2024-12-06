import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';

// ignore: must_be_immutable
class GoogleSignUp extends StatelessWidget {
  String text;
  VoidCallback onTap;
  GoogleSignUp({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return InkWell(
      onTap: onTap, 
      borderRadius: BorderRadius.circular(23),
      child: Material(
        color: AppColors.oRwhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
          side: const BorderSide(
            color: AppColors.oRBlack,
            width: 2.0,
          ),
        ),
        child: Container(
          width: mediaQuery.screenWidth * 0.8,
          height: mediaQuery.screenHeight * 0.06,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.google,
                width: mediaQuery.screenWidth * 0.09,
                height: mediaQuery.screenHeight * 0.03,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
