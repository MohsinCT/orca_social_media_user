import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: mediaQuery.screenWidth * 0.3,
          height: mediaQuery.screenHeight * 0.002,
          color: AppColors.oRLightGrey,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('or'),
        ),
        Container(
          width: mediaQuery.screenWidth * 0.3,
          height: mediaQuery.screenHeight * 0.002,
          color: AppColors.oRLightGrey,
        ),
      ],
    );
  }
}
