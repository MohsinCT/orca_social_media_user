import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:shimmer/shimmer.dart';

// class UserProfileShimmer extends StatelessWidget {
//   const UserProfileShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQueryHelper(context);
//     return SingleChildScrollView(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding:
//               EdgeInsets.symmetric(vertical: mediaQuery.screenHeight * 0.04),
//           child: ListTile(
//             leading: Shimmer.fromColors(
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[100]!,
//               child: CircleAvatar(
//                 maxRadius: 40,
//                 backgroundColor: Colors.grey[300],
//               ),
//             ),
//             trailing: Shimmer.fromColors(
//               baseColor: Colors.grey[300]!,
//               highlightColor: Colors.grey[100]!,
//               child: Container(
//                 width: 70,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 20,
//             width: mediaQuery.screenWidth * 0.5,
//             color: Colors.grey[300],
//           ),
//         ),
//         SizedBox(height: mediaQuery.screenHeight * 0.02),
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 15,
//             width: mediaQuery.screenWidth * 0.3,
//             color: Colors.grey[300],
//           ),
//         ),
//         SizedBox(height: mediaQuery.screenHeight * 0.02),
//         Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 60,
//             width: double.infinity,
//             color: Colors.grey[300],
//           ),
//         ),
//         SizedBox(height: mediaQuery.screenHeight * 0.02),
//         Row(
//           children: List.generate(
//             3,
//             (index) => Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: mediaQuery.screenWidth * 0.03),
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   height: 15,
//                   width: mediaQuery.screenWidth * 0.2,
//                   color: Colors.grey[300],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: mediaQuery.screenHeight * 0.02),
//         ListTile(
//           leading: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Icon(Icons.location_on, color: Colors.grey[300]),
//           ),
//           title: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               height: 12,
//               width: double.infinity,
//               color: Colors.grey[300],
//             ),
//           ),
//         ),
//         ListTile(
//           leading: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Icon(Icons.card_membership, color: Colors.grey[300]),
//           ),
//           title: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               height: 12,
//               width: double.infinity,
//               color: Colors.grey[300],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
//   }
// }

class UserProfileShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final mediaQuery = MediaQueryHelper(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        
        /// **Profile Picture & Stats Shimmer**
        Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                radius: mediaQuery.screenWidth * 0.15,
                backgroundColor: Colors.grey[300],
              ),
            ),
            SizedBox(height: mediaQuery.screenHeight * 0.015),
            ShimmerBox(width: mediaQuery.screenWidth * 0.4, height: mediaQuery.screenHeight * 0.02),
            SizedBox(height: mediaQuery.screenHeight * 0.01),
            ShimmerBox(width: mediaQuery.screenWidth * 0.3, height: mediaQuery.screenHeight * 0.02),
            SizedBox(height: mediaQuery.screenHeight * 0.02),
            ShimmerBox(width: mediaQuery.screenWidth * 0.6, height: mediaQuery.screenHeight * 0.06),
          ],
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02,),
        
        Padding(
          padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.2),
          child: Row(
            children: [
              ShimmerBox(width: mediaQuery.screenWidth * 0.1, height: mediaQuery.screenHeight * 0.02),
              SizedBox(width: mediaQuery.screenWidth * 0.08),
              ShimmerBox(width: mediaQuery.screenWidth * 0.15, height: mediaQuery.screenHeight * 0.02),
              SizedBox(width: mediaQuery.screenWidth * 0.08),
              ShimmerBox(width: mediaQuery.screenWidth * 0.15, height: mediaQuery.screenHeight * 0.02),
            ],
          ),
        ),
        
        SizedBox(height: mediaQuery.screenHeight * 0.025),
        
        /// **Edit Profile Button Shimmer**
        ShimmerBox(width: mediaQuery.screenWidth * 0.54, height: mediaQuery.screenHeight * 0.02),
        
        SizedBox(height: mediaQuery.screenHeight * 0.025),
        
        /// **Location & Membership Shimmer**
        ShimmerListTile(),
        ShimmerListTile(),
      ],
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// **Reusable Shimmer ListTile**
class ShimmerListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ShimmerBox(width: 24, height: 24),
      title: ShimmerBox(width: 150, height: 14),
    );
  }
}