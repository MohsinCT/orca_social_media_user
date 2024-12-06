import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';

// ignore: must_be_immutable
class StoryCircle extends StatelessWidget {
  List<String> circleItems;
  StoryCircle({super.key, required this.circleItems});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return SizedBox(
      height: mediaQuery.screenHeight * 0.15,
      child: ListView.builder(
        itemCount: circleItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
            child: Column(
              children: [
                // Check if it's the first item
                index == 0
                    ? GestureDetector(
                        onTap: () {},
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: mediaQuery.screenWidth * 0.22,
                              height: mediaQuery.screenHeight * 0.1,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.oRLightGrey,
                              ),
                            ),
                            Positioned(
                              right: mediaQuery.screenWidth * 0.01,
                              bottom: mediaQuery.screenHeight * 0.01,
                              child: Container(
                                width: mediaQuery.screenWidth * 0.06,
                                height: mediaQuery.screenWidth * 0.06,
                                decoration: const BoxDecoration(
                                  color: AppColors.oRBlack,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: mediaQuery.screenWidth * 0.22,
                        height: mediaQuery.screenHeight * 0.1,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.oRBlack,
                        ),
                      ),
                SizedBox(
                  height: mediaQuery.screenHeight * 0.01,
                ), // Space between circle and text
                Text(
                  circleItems[index], // Display the name under the circle
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
