import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final MediaQueryHelper mediaQuery;

  const ShimmerLoading({required this.mediaQuery, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaQuery.screenHeight * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer placeholders
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: mediaQuery.screenWidth * 0.8,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
