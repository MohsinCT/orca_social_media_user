import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/like_controller.dart';

import 'package:orca_social_media/controllers/save_post_controller.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_like_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CustomFollowingPostView extends StatefulWidget {
  final String id;
  final String userId;
  final String postId;
  final String username;
  final String profilPicture;
  final String usernameForCaption;
  final String caption;
  final dynamic latestPosts;
  final String image;
  final String date;

  const CustomFollowingPostView(
      {super.key,
      required this.userId,
      required this.postId,
      required this.username,
      required this.image,
      required this.date,
      required this.profilPicture,
      required this.usernameForCaption,
      this.latestPosts,
      required this.caption, required this.id});

  @override
  State<CustomFollowingPostView> createState() => _CustomFollowingPostViewState();
}

class _CustomFollowingPostViewState extends State<CustomFollowingPostView> {

  
   @override
  void initState() {
    super.initState();
    Provider.of<LikeProvider>(context, listen: false)
          .setInitialLikeStatus(widget.userId , widget.postId );
  }
  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQueryHelper(context);
    final likeProvider = Provider.of<LikeProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.screenHeight * 0.02),
      child: Container(
        width: mediaQuery.screenWidth,
        color: AppColors.oRLightGrey,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.profilPicture),
              ),
              title: Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.black),
                            title: const Text('View profile',
                                style: TextStyle(color: Colors.black)),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfile(userId: widget.userId))),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            if (widget.latestPosts != null) ...[
              CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.grey),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "${widget.username} : ${widget.caption}",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.latestPosts['date'],
                    style: TextStyle(
                      fontSize: mediaQuery.screenWidth * 0.025,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<LikeProvider>(
                    builder: (context, likeProvider, child) {
                      return Row(
                      children: [
                        LikeButton(
                          onPressed: () {
                            likeProvider.toggleLike(widget.userId, widget.postId);
                          },
                          isLiked: likeProvider.isLiked(widget.postId),
                        ),
                        Text(likeProvider.likeCount(widget.postId).toString()),
                      ],
                    );
                    },
                    child: Row(
                      children: [
                        LikeButton(
                          onPressed: () {
                            likeProvider.toggleLike(widget.userId, widget.postId);
                          },
                          isLiked: likeProvider.isLiked(widget.postId),
                        ),
                        Text(likeProvider.likeCount(widget.postId).toString()),
                      ],
                    ),
                  ),
                  Consumer<SavePostProvider>(
                    builder: (context, savedPostProvider, child) {
                      return IconButton(
                        icon: Icon(
                          savedPostProvider.savedPosts.any(
                                  (post) => post['id'] == widget.latestPosts['id'])
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: savedPostProvider.savedPosts.any(
                                  (post) => post['id'] == widget.latestPosts['id'])
                              ? Colors.black
                              : null,
                        ),
                        onPressed: () {
                          savedPostProvider.togglePostToSave(
                            widget.latestPosts['id'],
                            widget.userId,
                            widget.latestPosts,
                          );
                          showCustomSnackBar(
                            context,
                            Icons.bookmark_added,
                            "You've Saved ${widget.username} post",
                            1,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void showCustomSnackBar(
    BuildContext context, IconData icon, String text, int sec) {
  final mediaQuery = MediaQueryHelper(context);

  ScaffoldMessenger.of(context).showSnackBar(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: Duration(seconds: sec),
    ),
  );
}
