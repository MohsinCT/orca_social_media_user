import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:provider/provider.dart';
import 'package:orca_social_media/controllers/follow_button_controller.dart';

class FollowButton extends StatelessWidget {
  final String userId;
   

  const FollowButton({required this.userId, Key? key, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final followProvider = Provider.of<FollowProvider>(context , listen: false);
    Future.microtask(() {
      followProvider.initFollowState(userId);

    });
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

                  // Show SnackBar based on follow/unfollow acti
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



