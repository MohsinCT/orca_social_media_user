import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/media_provider.dart';
import 'package:orca_social_media/controllers/save_post_controller.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_like_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_post_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostView extends StatefulWidget {
  final String userId;
  

  const PostView({super.key, required this.userId, });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {


  final currentUser = FirebaseAuth.instance.currentUser!;
  
  @override
  void initState() {
    super.initState();
    
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MediaProvider>(context, listen: false)
          .fetchFollowingsWithLatestPost(widget.userId);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        if (mediaProvider.isLoading) {
          return const Center(child: PostViewShimmer());
        } else if (mediaProvider.errorMessage != null) {
          return Center(child: Text(mediaProvider.errorMessage!));
        } else if (mediaProvider.followingDataWithPosts.isEmpty) {
          return Container(
              width: mediaQuery.screenWidth,
              height: mediaQuery.screenHeight * 0.4,
              child:
                  Center(child: Text('Follow some users and see their posts')));
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mediaProvider.followingDataWithPosts.length,
          itemBuilder: (context, index) {
            final following = mediaProvider.followingDataWithPosts[index];
            final latestPosts = following['latestPost'];
            // bool isLiked = mediaProvider.isPostLiked(latestPosts?['id']);
          bool  isLiked = List<String>.from(latestPosts['likedUsers'] ?? []).contains(currentUser.email);

            return Padding(
              padding: EdgeInsets.only(bottom: mediaQuery.screenHeight * 0.02),
              child: Container(
                width: mediaQuery.screenWidth,
                color: AppColors.oRLightGrey,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(following['profilePicture'] ?? ''),
                      ),
                      title: Text(
                        following['username'] ?? '',
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
                                    leading: const Icon(Icons.report,
                                        color: Colors.red),
                                    title: const Text('Report',
                                        style: TextStyle(color: Colors.red)),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (latestPosts != null) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.screenWidth * 0.0,
                        ),
                        child: SizedBox(
                          width: mediaQuery.screenWidth,
                          height: mediaQuery.screenHeight * 0.4,
                          child: CachedNetworkImage(
                            imageUrl: latestPosts['image'] ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          "${following['username']} : ${latestPosts['caption'] ?? 'nothing in caption'}",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: mediaQuery.screenWidth * 0.03),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            latestPosts['date'],
                            style: TextStyle(
                              fontSize: mediaQuery.screenWidth * 0.025,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LikeButton(
                            onPressed: (){
                              setState(() {
                                isLiked = !isLiked;
                              });
                              DocumentReference posRef = FirebaseFirestore.instance.collection("users").doc(following['id']).collection("posts").doc(latestPosts['id']);
                              if(isLiked){
                                posRef.update({
                                  'likedUsers':FieldValue.arrayUnion([currentUser.email])
                                });
                              } else {
                                posRef.update({
                                  'likedUsers':FieldValue.arrayRemove([currentUser.email])
                                });
                              }
                            },
                            isLiked: isLiked,
                          ),

                          Text('${List<String>.from(latestPosts['likedUsers'] ?? [])}'),


                          SizedBox(width: mediaQuery.screenWidth * 0.58),
                           Consumer<SavePostProvider>(
                            builder: (context, savedPostProvider, child) {
                              return  IconButton(
                                  icon:  Icon(
                                    savedPostProvider.savedPosts.any((post) => post['id'] == latestPosts['id'])
                                     ? Icons.bookmark
                                     : Icons.bookmark_border,
                                     color: savedPostProvider.savedPosts.any((post) => post['id'] == latestPosts['id'])
                                     ? Colors.black
                                     :null
                                    ),
                                  onPressed: () async {
                                    savedPostProvider.togglePostToSave(latestPosts['id'], widget.userId, latestPosts);
                                    showCustomSnackBar(context, Icons.bookmark_added, "You've Saved ${latestPosts['username']} post", 1);
                                    
                             
                                  },
                                );
                            },
                             
                           )
                           
                        ],
                      ),
                    ],
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

void showCustomSnackBar(
    BuildContext context, IconData icon, String text, int sec) {
  final mediaQuery = MediaQueryHelper(context);

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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: Duration(seconds: sec),
  );
}
