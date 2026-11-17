import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/edit_profile.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/followers.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/followings.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_message_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_text.dart';
import 'package:provider/provider.dart';

class UsersDetails extends StatelessWidget {
  final UserModel user;
  final String userId;
  final String userImage;
  final String username;
  final String nickname;
  final String bio;
  final String location;
  final String date;
  final int followersCount;
  final int followingCount;
  final int postCount;
  const UsersDetails({
    super.key,
    required this.user,
    required this.userImage,
    required this.username,
    required this.nickname,
    required this.bio,
    required this.location,
    required this.date,
    required this.followersCount,
    required this.followingCount,
    required this.userId,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? currentUser = userProvider.getLoggedUserId();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: mediaQuery.screenHeight * 0.02),

        /// **Profile Picture & Stats**
        Column(
          children: [
            GestureDetector(
              onLongPress: () {
                _showAvatarDetail(context, userImage);
              },
              child: CircleAvatar(
                radius: mediaQuery.screenWidth * 0.15,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: CachedNetworkImageProvider(userImage),
                child:
                    userImage.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
              ),
            ),
            SizedBox(height: mediaQuery.screenHeight * 0.015),
            Column(
              children: [
                Text(
                  '@$username',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: mediaQuery.screenHeight * 0.01),
                Text(
                  nickname == 'Add nickname' ? username : nickname,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: mediaQuery.screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.screenWidth * 0.08,
                  ),
                  child:
                      bio == 'Add Bio'
                          ? const SizedBox.shrink()
                          : Text(
                            bio,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                ),
              ],
            ),
            SizedBox(height: mediaQuery.screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.2),
              child: Row(
                children: [
                  CustomText(count: postCount, text: 'Posts'),
                  SizedBox(width: mediaQuery.screenWidth * 0.08),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Followers(userId: userId),
                        ),
                      );
                    },
                    child: CustomText(count: followersCount, text: 'Followers'),
                  ),
                  SizedBox(width: mediaQuery.screenWidth * 0.08),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Followings(userId: userId),
                        ),
                      );
                    },
                    child: CustomText(
                      count: followingCount,
                      text: 'Followings',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: mediaQuery.screenHeight * 0.025),

        userId != currentUser
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FollowButton(userId: userId),
                SizedBox(width: mediaQuery.screenWidth * 0.04),
                CustomMessageButton(userID: userId, username: username),
              ],
            )
            : GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(user: user),
                  ),
                );
              },
              child: Container(
                width: mediaQuery.screenWidth * 0.54,
                height: mediaQuery.screenHeight * 0.03,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.oRGrey300f,
                ),
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

        SizedBox(height: mediaQuery.screenHeight * 0.025),

        /// **Location & Membership**
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.redAccent),
          title: Text(
            location == 'Add location' ? 'Not added' : user.location,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.card_membership, color: Colors.blueAccent),
          title: Text(
            'Member since ${user.date}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
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
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),
            // Centered avatar image
            Center(
              child: CircleAvatar(
                radius:
                    MediaQuery.of(context).size.width *
                    0.4, // Adjust the radius
                backgroundColor: Colors.transparent, // Transparent background
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    placeholder:
                        (context, url) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
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
