import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: post.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
