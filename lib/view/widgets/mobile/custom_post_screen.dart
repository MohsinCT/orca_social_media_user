import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/like_controller.dart';

import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_like_button.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final String userProfile;
  final String username;
  final String postedImage;
  final String usernameForcaption;
  final String caption;
  final String date;
  final String userId;
  final String postId;
  final VoidCallback delete;
  final VoidCallback edit;
  final List<String> likes;
  final VoidCallback onPressed;
 
  const PostPage({
    super.key,
    required this.userProfile,
    required this.username,
    required this.postedImage,
    required this.usernameForcaption,
    required this.caption,
    required this.date,
    required this.userId,
    required this.postId,
    required this.edit,
    required this.likes,
    required this.delete,
    required this.onPressed,
  });
 
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();

    // Initialize like status when the page is opened
    Future.microtask(() {
      Provider.of<LikeProvider>(context, listen: false)
          .setInitialLikeStatus(widget.userId, widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final likeProvider = Provider.of<LikeProvider>(context);

    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyleading: true,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userProfile),
            ),
            SizedBox(width: mediaQuery.screenWidth * 0.03),
            Text(widget.username),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                widget.edit();
              } else if (value == 'delete') {
                widget.delete();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: widget.edit,
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: widget.delete,
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.screenHeight * 0.03,
          horizontal: mediaQuery.screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              width: mediaQuery.screenWidth * 0.9,
              height: mediaQuery.screenHeight * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(widget.postedImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: mediaQuery.screenHeight * 0.04),

            // Like Button Row
            Row(
              children: [
                LikeButton(
                  onPressed: () {
                    likeProvider.toggleLike(widget.userId, widget.postId);
                  },
                  isLiked: likeProvider.isLiked(widget.postId),
                ),
                SizedBox(width: mediaQuery.screenWidth * 0.02),
                Text(
                  likeProvider.likeCount(widget.postId).toString(),
                  style: TextStyle(fontSize: mediaQuery.screenWidth * 0.04),
                ),
              ],
            ),
            SizedBox(height: mediaQuery.screenHeight * 0.01),

            // Caption and User Info
            Text(
              '${widget.usernameForcaption} : ${widget.caption}',
              style: TextStyle(
                fontSize: mediaQuery.screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: mediaQuery.screenWidth * 0.02),

            // Date Information
            Text(
              'Posted on: ${widget.date}',
              style: TextStyle(
                fontSize: mediaQuery.screenWidth * 0.03,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
