import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:shimmer/shimmer.dart';

class GridVieShimmer extends StatelessWidget {
  const GridVieShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return GridView.builder(
            itemCount: 10, // Show shimmer placeholders
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: mediaQuery.screenWidth * 0.04,
              mainAxisSpacing: mediaQuery.screenHeight * 0.02,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                      ),
                      SizedBox(height: mediaQuery.screenHeight * 0.02),
                      Container(
                        width: mediaQuery.screenWidth * 0.3,
                        height: 15,
                        color: Colors.grey[200],
                      ),
                      SizedBox(height: mediaQuery.screenHeight * 0.02),
                      Container(
                        width: mediaQuery.screenWidth * 0.2,
                        height: 10,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
    ;
  }
}