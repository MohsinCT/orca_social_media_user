import 'package:flutter/material.dart';

class PostDialog extends StatelessWidget {
  final String sharePost;
  final String shareMessage;
  final String shareStory;
  final VoidCallback sharePosts;
  final VoidCallback shareMessages;
  final VoidCallback shareStories;

  const PostDialog(
      {super.key,
      required this.sharePost,
      required this.shareMessage,
      required this.shareStory,
      required this.sharePosts,
      required this.shareMessages,
      required this.shareStories});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        listTile(Icons.photo, sharePost, sharePosts),
        // Divider(),
        // listTile(Icons.message, shareMessage, shareMessages) ,
        Divider(),
        listTile(Icons.timer, shareStory, (shareStories)),
      
        
      ],
    ),
    );
  }

  Widget listTile(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}
