import 'package:flutter/material.dart';

class PostDialog extends StatelessWidget {
  final String sharePost;
  final String shareMessage;
  final String shareStory;
  final VoidCallback sharePosts;
  final VoidCallback shareMessages;
  final VoidCallback shareStories;

  const PostDialog({
    super.key,
    required this.sharePost,
    required this.shareMessage,
    required this.shareStory,
    required this.sharePosts,
    required this.shareMessages,
    required this.shareStories,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10,
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _listTile(Icons.photo, sharePost, sharePosts, Colors.blue),
            const Divider(),
            // Uncomment if needed
            // _listTile(Icons.message, shareMessage, shareMessages, Colors.green),
            // const Divider(),
            _listTile(Icons.timer, shareStory, shareStories, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _listTile(
      IconData icon, String text, VoidCallback onTap, Color iconColor) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
