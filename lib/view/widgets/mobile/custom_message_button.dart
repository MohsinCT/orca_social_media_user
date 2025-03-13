import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/follow_button_controller.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/chat_screen.dart';
import 'package:provider/provider.dart';

class CustomMessageButton extends StatelessWidget {
  final String userID;
  final String username;

  const CustomMessageButton({
    super.key,
    required this.userID,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Consumer<FollowProvider>(
      builder: (context, followProvider, child) {
        final isFollowing = followProvider.isFollowing(userID);
        return isFollowing
            ? InkWell(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          user: ChatUser(id: userID), userID: userID)));
                },
                child: Container(
                  width: mediaQuery.screenWidth * 0.24,
                  height: mediaQuery.screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: AppColors.oRBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Text(
                      'Message',
                      style: TextStyle(
                        color: AppColors.oRwhite,
                      ),
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.lock,
                              color: Colors
                                  .white), // Lock icon for messaging restriction
                          SizedBox(width: mediaQuery.screenWidth * 0.03),
                          Expanded(
                            child: Text(
                              'Follow $username to message',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.oRBlack,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                },
                child: Container(
                  width: mediaQuery.screenWidth * 0.24,
                  height: mediaQuery.screenHeight * 0.04,
                  decoration: BoxDecoration(
                    color: AppColors.oRwhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.orGrey),
                  ),
                  child: Center(
                    child: Text(
                      'Message',
                      style: TextStyle(
                        color: AppColors.orGrey,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
