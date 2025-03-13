import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/save_post_controller.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SavedPostsScreen extends StatelessWidget {
  final String userId;
  const SavedPostsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final savedPostsProvider = Provider.of<SavePostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Posts"),
      ),
      body: savedPostsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : savedPostsProvider.savedPosts.isEmpty
              ? const Center(child: Text("No saved posts yet"))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Two columns
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: savedPostsProvider.savedPosts.length,
                  itemBuilder: (context, index) {
                    final post = savedPostsProvider.savedPosts[index];

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: post['image'] ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                ),
    );
  }
}
