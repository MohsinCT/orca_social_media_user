import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/follow_button_controller.dart';
import 'package:provider/provider.dart';

class FollowButton extends StatelessWidget {
  final String userId;

  const FollowButton({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final followProvider = Provider.of<FollowProvider>(context);

    final isFollowing = followProvider.isFollowing(userId);
    final buttonText = isFollowing ? 'Unfollow' : 'Follow';

    return InkWell(
      onTap: () async {
        try {
          await followProvider.toggleFollow(userId);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      child: Container(
        width: mediaQuery.screenWidth * 0.24,
        height: mediaQuery.screenHeight * 0.04,
        decoration: BoxDecoration(
          color: isFollowing ? AppColors.oRwhite : AppColors.oRBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: isFollowing ? AppColors.oRBlack : AppColors.oRwhite,
            ),
          ),
        ),
      ),
    );
  }
}
