import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:provider/provider.dart';
import 'package:orca_social_media/controllers/follow_button_controller.dart';

class FollowButton extends StatelessWidget {
  final String userId;
  final String username;

  const FollowButton({required this.userId, Key? key, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Consumer<FollowProvider>(
      builder: (context, followProvider, child) {
        final isFollowing = followProvider.isFollowing(userId);
        final isLoading = followProvider.isLoading(userId);

        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  followProvider.toggleFollow(userId);

                  // Show SnackBar based on follow/unfollow action
                  if (isFollowing) {
                    showCustomSnackBar(
                        context,
                        Icons.person_remove, // Unfollow icon
                        "You unfollowed $username",
                        2);
                  } else {
                    showCustomSnackBar(
                        context,
                        Icons.person_add_alt_1_outlined, // Follow icon
                        "You're following $username",
                        2);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.white : Colors.black,
            side: BorderSide(color: Colors.black),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? SizedBox(
                  width: mediaQuery.screenWidth * 0.12,
                  height: mediaQuery.screenHeight * 0.01,
                  child: CupertinoActivityIndicator(
                    radius: 10,
                  ),
                )
              : Text(isFollowing ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                      color: isFollowing ? Colors.black : Colors.white)),
        );
      },
    );
  }
}

void showCustomSnackBar(
    BuildContext context, IconData icon, String text, int sec) {
  final mediaQuery = MediaQueryHelper(context);

  SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: mediaQuery.screenWidth * 0.03),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
    backgroundColor: AppColors.oRBlack,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: Duration(seconds: sec),
  );
}
