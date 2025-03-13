import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/media_provider.dart';
import 'package:provider/provider.dart';

class CommentBottomSheet extends StatelessWidget {
  final String userId;
  final String postId;
  const CommentBottomSheet({Key? key, required this.userId, required this.postId,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  final TextEditingController controller = TextEditingController();
  final mediaProvider = Provider.of<MediaProvider>(context ,listen: false );

    return IconButton(
      icon: const Icon(Icons.comment),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Drag indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Comments List
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10, // Replace with dynamic comment count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile picture
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      ''),
                                ),
                                const SizedBox(width: 10),
                                // Comment text and username
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'username',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' Pandi karimpara ponara mone....',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                       Text(
                                        '1 min',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Divider
                    const Divider(thickness: 1),
                    // Comment Input Field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                          controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: (){}
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
