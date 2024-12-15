import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:shimmer/shimmer.dart';

class ListviewShimmer extends StatelessWidget {
  const ListviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal, // Scroll horizontally
      itemCount: 6, // Placeholder count
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: mediaQuery.screenWidth * 0.7,
            margin:
                EdgeInsets.symmetric(horizontal: mediaQuery.screenWidth * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 225, 225),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200], // Placeholder color
                ),
                SizedBox(
                  width: mediaQuery.screenWidth * 0.1,
                ),
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.grey[300], // Placeholder for text
                ),
              ],
            ),
          ),
        );
      },
    );
    
  }
}
