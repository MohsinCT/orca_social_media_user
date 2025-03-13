import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';

import 'package:orca_social_media/view/widgets/mobile/custom_user_shimmer.dart';
import 'package:orca_social_media/view/widgets/mobile/users_details.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder<UserModel?>(
      future: userProvider.fetchUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return UserProfileShimmer();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

          return UsersDetails(
              user: user,
              userImage: user.profilPicture,
              username: user.username,
              nickname: user.nickname,
              bio: user.bio,
              location: user.location,
              date: user.date,
              followersCount: user.followersCount,
              followingCount: user.followingCount,
              userId: user.id,
              postCount: user.postCount);

          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SizedBox(height: mediaQuery.screenHeight * 0.02),

          //     /// **Profile Picture & Stats**
          //     Column(
          //       children: [
          //         GestureDetector(
          //           onLongPress: () {
          //             _showAvatarDetail(context, user.profilPicture);
          //           },
          //           child: CircleAvatar(
          //             radius: mediaQuery.screenWidth * 0.15,
          //             backgroundColor: Colors.grey.shade200,
          //             backgroundImage:
          //                 CachedNetworkImageProvider(user.profilPicture),
          //             child: user.profilPicture.isEmpty
          //                 ? const Icon(Icons.person,
          //                     size: 40, color: Colors.grey)
          //                 : null,
          //           ),
          //         ),
          //         SizedBox(height: mediaQuery.screenHeight * 0.015),
          //         Column(
          //           children: [
          //             Text(
          //               '@${user.username}',
          //               style: TextStyle(
          //                   fontSize: 20, fontWeight: FontWeight.bold),
          //             ),
          //             SizedBox(height: mediaQuery.screenHeight * 0.01),
          //             user.nickname == 'Add nickname'
          //                 ? SizedBox.shrink()
          //                 : Text(
          //                     user.nickname,
          //                     style: TextStyle(
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.w500,
          //                         color: Colors.grey.shade700),
          //                   ),
          //             SizedBox(height: mediaQuery.screenHeight * 0.02),
          //             Padding(
          //               padding: EdgeInsets.symmetric(
          //                   horizontal: mediaQuery.screenWidth * 0.08),
          //               child: user.bio == 'Add Bio'
          //                   ? SizedBox.shrink()
          //                   : Text(
          //                       user.bio,
          //                       textAlign: TextAlign.center,
          //                       style: TextStyle(
          //                           fontSize: 14, color: Colors.grey.shade800),
          //                     ),
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: mediaQuery.screenHeight * 0.01,
          //         ),
          //         Padding(
          //           padding:
          //               EdgeInsets.only(left: mediaQuery.screenWidth * 0.2),
          //           child: Container(
          //             child: Row(
          //               children: [
          //                 CustomText(count: user.postCount, text: 'Posts'),
          //                 SizedBox(width: mediaQuery.screenWidth * 0.08),
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.of(context).push(MaterialPageRoute(
          //                         builder: (context) =>
          //                             Followers(userId: user.id)));
          //                   },
          //                   child: CustomText(
          //                       count: user.followersCount, text: 'Followers'),
          //                 ),
          //                 SizedBox(width: mediaQuery.screenWidth * 0.08),
          //                 GestureDetector(
          //                   onTap: () {
          //                     Navigator.of(context).push(MaterialPageRoute(
          //                         builder: (context) =>
          //                             Followings(userId: user.id)));
          //                   },
          //                   child: CustomText(
          //                       count: user.followingCount, text: 'Followings'),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),

          //     SizedBox(height: mediaQuery.screenHeight * 0.025),

          //     /// **Edit Profile Button**
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.of(context).push(MaterialPageRoute(
          //             builder: (context) => EditProfile(user: user)));
          //       },
          //       child: Container(
          //         width: mediaQuery.screenWidth * 0.54,
          //         height: mediaQuery.screenHeight * 0.03,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: AppColors.oRGrey300f),
          //         child: Center(
          //             child: Text(
          //           'Edit Profile',
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         )),
          //       ),
          //     ),

          //     SizedBox(height: mediaQuery.screenHeight * 0.025),

          //     /// **Location & Membership**
          //     ListTile(
          //       leading: Icon(Icons.location_on, color: Colors.redAccent),
          //       title: Text(
          //         user.location,
          //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          //       ),
          //     ),
          //     ListTile(
          //       leading: Icon(Icons.card_membership, color: Colors.blueAccent),
          //       title: Text(
          //         'Member since ${user.date}',
          //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          //       ),
          //     ),
          //   ],
          // );
        } else {
          return const Center(child: Text('User not found.'));
        }
      },
    );
  }
}

Widget _buildShimmerEffect(MediaQueryHelper mediaQuery) {
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

void _showAvatarDetail(BuildContext context, String imageUrl) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // Ensures the dialog fills the screen
        child: Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 13, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            // Centered avatar image
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width *
                    0.4, // Adjust the radius
                backgroundColor: Colors.transparent, // Transparent background
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 60),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
