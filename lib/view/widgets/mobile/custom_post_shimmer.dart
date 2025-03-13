import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:shimmer/shimmer.dart';

class PostViewShimmer extends StatelessWidget {
  const PostViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.screenHeight * 0.02),
          child: Container(
            width: mediaQuery.screenWidth,
            color: AppColors.oRLightGrey,
            child: Column(
              children: [
                ListTile(
                  leading: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child:
                        CircleAvatar(radius: 24, backgroundColor: Colors.grey),
                  ),
                  title: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: mediaQuery.screenWidth * 0.4,
                      height: 10,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Icon(Icons.more_vert, color: Colors.grey[300]),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: mediaQuery.screenWidth,
                    height: mediaQuery.screenHeight * 0.4,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: mediaQuery.screenWidth * 0.6,
                      height: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Icon(Icons.favorite_border, color: Colors.grey),
                    ),
                    SizedBox(width: mediaQuery.screenWidth * 0.58),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Icon(Icons.bookmark_border, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Actual post UI when data is loaded
      },
    );
  }
}
