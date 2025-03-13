import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';

class StoryShimmer extends StatelessWidget {
  const StoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return SizedBox(
      height: mediaQuery.screenHeight * 0.15,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.oRLightGrey.withOpacity(0.5),
                  highlightColor: Colors.white.withOpacity(0.3),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: mediaQuery.screenWidth * 0.22,
                        height: mediaQuery.screenHeight * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.oRLightGrey,
                        ),
                      ),
                      if (index == 0)
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
                ),
                SizedBox(height: mediaQuery.screenHeight * 0.01),
                Shimmer.fromColors(
                  baseColor: AppColors.oRLightGrey.withOpacity(0.5),
                  highlightColor: Colors.white.withOpacity(0.3),
                  child: Container(
                    width: mediaQuery.screenWidth * 0.12,
                    height: 12,
                    color: AppColors.oRLightGrey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
