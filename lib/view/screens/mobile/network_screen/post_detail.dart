
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/media_provider.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_like_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostDetailDialog extends StatelessWidget {
  final String userProfile;
  final String username;
  final String postedImage;
  final String usernameForcaption;
  final String caption;
  final String date;
  final String userId;
  final String postId;
  final List<String> likes;
  final VoidCallback onPressed;

  const PostDetailDialog({
    super.key,
    required this.userProfile,
    required this.username,
    required this.postedImage,
    required this.usernameForcaption,
    required this.caption,
    required this.date,
    required this.onPressed,
    required this.userId,
    required this.postId,
    required this.likes,
  });
 
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final mediaProvider = Provider.of<MediaProvider>(context);

    bool isLiked = mediaProvider.isPostLiked(postId);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: mediaQuery.screenWidth,
        height: mediaQuery.screenHeight * 0.6,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: mediaQuery.screenWidth,
                height: mediaQuery.screenHeight,
                child: Column(
                  children: [
                    // User Info
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userProfile),
                      ),
                      title: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: onPressed,
                        icon: IconButton(
                          onPressed: () {
                            _showDeleteDialog(context, mediaProvider);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),

                    // Post Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: postedImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: mediaQuery.screenHeight * 0.4,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.grey,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),

                    // Caption
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "$usernameForcaption : $caption",
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),

                    // Date
                    Padding(
                      padding:
                          EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: mediaQuery.screenWidth * 0.025,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Consumer<MediaProvider>(
                      builder: (context, mediaProvider, child) {
                        return Row(
                          children: [
                            LikeButton(
                              onPressed: () {
                                mediaProvider.toggleLike(postId, userId);
                              },
                              isLiked: isLiked,
                            ),
                            Text(mediaProvider.isPostLiked(postId)
                                ? "${likes.length + 1}"
                                : "${likes.length}")
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, MediaProvider mediaProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog after action
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
