import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/post_model.dart';
import 'package:provider/provider.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: Provider.of<UserProvider>(context, listen: false).fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Posts Available'),
          );
        }

        final posts = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              child: post.image.isNotEmpty
                  ? Image.network(
                      post.image,
                      fit: BoxFit.cover,
                    )
                  : post.video.isNotEmpty
                      ? const Icon(
                          Icons.video_library,
                          color: Colors.grey,
                        )
                      : const Center(
                          child: Text('No Media'),
                        ),
            );
          },
          itemCount: posts.length,
        );
      },
    );
  }
}
