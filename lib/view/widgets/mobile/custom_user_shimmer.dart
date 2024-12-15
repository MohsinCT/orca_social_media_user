import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: mediaQuery.screenHeight * 0.04),
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                maxRadius: 40,
                backgroundColor: Colors.grey[300],
              ),
            ),
            trailing: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20,
            width: mediaQuery.screenWidth * 0.5,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 15,
            width: mediaQuery.screenWidth * 0.3,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 60,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.screenWidth * 0.03),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 15,
                  width: mediaQuery.screenWidth * 0.2,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Icon(Icons.location_on, color: Colors.grey[300]),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
        ),
        ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Icon(Icons.card_membership, color: Colors.grey[300]),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
        ),
      ],
    ),
  );
  }
}