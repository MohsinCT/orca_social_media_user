import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/functions.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final customRoute = CustomRoute();
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height:
                mediaQuery.screenHeight * 0.2, // Spacing for all screen sizes
          ),
          Image.asset(
            AppImages.orcaLogoTrans,
            width: mediaQuery.screenWidth * 0.9, // For smaller screens (mobile)
            height: mediaQuery.screenHeight * 0.4,
            // For larger screens (web/tablet
          ),
          SizedBox(
            height: mediaQuery.screenHeight * 0.12,
          ),
          const Text(
            'Some Quote goes Here',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: mediaQuery.screenHeight * 0.03,
          ),
          InkWell(
            onTap: () {
              //Navigator.of(context).pushReplacement(customRoute.createCustomRoute());
              Navigator.pushReplacement(context, customRoute.createCustomRoute());
            },
            child: Container(
              width: mediaQuery.screenWidth * 0.8,
              height: mediaQuery.screenHeight * 0.07,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Responsive font size
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
