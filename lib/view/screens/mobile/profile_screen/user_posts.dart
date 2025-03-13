import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/counter.dart';
import 'package:orca_social_media/controllers/media_provider.dart';
import 'package:orca_social_media/models/post_model.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_post_grid_shimmer.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_post_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postCount = Provider.of<CounterProvider>(context, listen: false);
    final TextEditingController controller = TextEditingController();
    final currentUser = userProvider.getLoggedUserId();
    return FutureBuilder<Map<String, dynamic>?>(
      // future: Future.wait({
      //   Provider.of<UserProvider>(context, listen: false).fetchPosts(),
      //   Provider.of<UserProvider>(context, listen: false).fetchUserDetails()
      // }),
      future: mediaProvider.fetchUserAndPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: PostGridShimmer());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Posts Available'),
          );
        }

        // final posts = snapshot.data![0];
        final user = snapshot.data!['user'] as UserModel;
        final posts = snapshot.data!['posts'] as List<PostModel>;
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
 
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostPage(
                        userProfile: user.profilPicture,
                        username: user.username,
                        postedImage: post.image,
                        usernameForcaption: user.username,
                        caption: post.caption,
                        date: post.date,
                        postId: post.id,
                        userId: currentUser!,
                        likes: List<String>.from(post.likedUsers),
                        onPressed: () {},
                        edit: () {
                          editCaptionDialog(
                              context, controller, post.caption, post.id);
                        },
                        delete: () async {
                          bool? confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text(
                                    "Are you sure you want to delete this post?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text("Delete",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmDelete == true) {
                            // Show the loading dialog while deleting
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // Prevent closing during deletion
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Deleting Post"),
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 15),
                                      Text("Please wait..."),
                                    ],
                                  ),
                                );
                              },
                            );

                            // Perform deletion
                            await mediaProvider.deletePost(post.id);
                            postCount.decrementPostCount(user.id);

                            Navigator.of(context).pop();

                            // Show success message
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Post Deleted"),
                                  content: Text(
                                      "The post has been successfully deleted."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _handleRefresh(context);
                                        Navigator.of(context)
                                            .pop(); // Close the success dialog
                                        Navigator.of(context)
                                            .pop(); // Close the PostPage
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        })));
              },
              child:
                  // Delete Button Positioned at Top Right

                  // Post Image Container
                  Container(
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
                    : const Center(
                        child: Text('No Media'),
                      ),
              ),
            );
          },
          itemCount: posts.length,
        );
      },
    );
  }
}

void editCaptionDialog(BuildContext context,
    TextEditingController captionController, String oldCaption, String postId) {
  captionController.text = oldCaption;
  final postController = Provider.of<MediaProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Caption"),
        content: TextField(
          controller: captionController,
          decoration: const InputDecoration(
            hintText: "Enter new caption",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String newCaption = captionController.text.trim();
              if (newCaption.isNotEmpty && newCaption != oldCaption) {
                await postController.updatePostCaption(postId, newCaption);
                postController.refresh(); // Refresh UI if needed
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Caption updated successfully")),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}

Future<void> _handleRefresh(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  await userProvider.refresh();
}
