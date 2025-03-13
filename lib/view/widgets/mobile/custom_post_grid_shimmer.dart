import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostGridShimmer extends StatelessWidget {
  const PostGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: 1.0,
      ),
      shrinkWrap: true,
      itemCount: 10, // Show shimmer effect when empty
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
                color: Colors.grey),
          ),
        );
      },
    );
  }
}
