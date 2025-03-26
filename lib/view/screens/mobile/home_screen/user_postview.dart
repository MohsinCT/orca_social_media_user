import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/like_controller.dart';
import 'package:orca_social_media/controllers/media_provider.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_post_shimmer.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_post_view.dart';
import 'package:provider/provider.dart';

class PostView extends StatelessWidget {
  final String userId;

  const PostView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<MediaProvider>().fetchFollowingsWithLatestPost(userId);
    });

    final mediaQuery = MediaQueryHelper(context);
    // final currentUser = FirebaseAuth.instance.currentUser!;

    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        if (mediaProvider.isLoading) {
          return const Center(child: PostViewShimmer());
        } else if (mediaProvider.errorMessage != null) {
          return Center(child: Text(mediaProvider.errorMessage!));
        } else if (mediaProvider.followingDataWithPosts.isEmpty) {
          return SizedBox(
            width: mediaQuery.screenWidth,
            height: mediaQuery.screenHeight * 0.4,
            child: const Center(
                child: Text('Follow some users and see their posts')),
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mediaProvider.followingDataWithPosts.length,
          itemBuilder: (context, index) {
            final following = mediaProvider.followingDataWithPosts[index];
            final latestPosts = following['latestPost'];
            final likeProvider =
                Provider.of<LikeProvider>(context, listen: false);

            return CustomFollowingPostView(
              id: userId,
              userId: following['id'],
              postId: latestPosts['id'],
              username: following['username'],
              image: latestPosts['image'],
              date: latestPosts['date'],
              profilPicture: following['profilePicture'],
              usernameForCaption: following['username'],
              caption: latestPosts['caption'],
              latestPosts: latestPosts,
            );

            // return Padding(
            //   padding: EdgeInsets.only(bottom: mediaQuery.screenHeight * 0.02),
            //   child: Container(
            //     width: mediaQuery.screenWidth,
            //     color: AppColors.oRLightGrey,
            //     child: Column(
            //       children: [
            //         ListTile(
            //           leading: CircleAvatar(
            //             backgroundImage:
            //                 NetworkImage(following['profilePicture'] ?? ''),
            //           ),
            //           title: Text(
            //             following['username'] ?? '',
            //             style: const TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //           trailing: IconButton(
            //             icon: const Icon(Icons.more_vert),
            //             onPressed: () {
            //               showModalBottomSheet(
            //                 context: context,
            //                 builder: (context) {
            //                   return Column(
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       ListTile(
            //                         leading: const Icon(Icons.report,
            //                             color: Colors.red),
            //                         title: const Text('Report',
            //                             style: TextStyle(color: Colors.red)),
            //                         onTap: () => Navigator.pop(context),
            //                       ),
            //                     ],
            //                   );
            //                 },
            //               );
            //             },
            //           ),
            //         ),
            //         if (latestPosts != null) ...[
            //           CachedNetworkImage(
            //             imageUrl: latestPosts['image'] ?? '',
            //             fit: BoxFit.cover,
            //             placeholder: (context, url) => Shimmer.fromColors(
            //               baseColor: Colors.grey[300]!,
            //               highlightColor: Colors.grey[100]!,
            //               child: Container(color: Colors.grey),
            //             ),
            //             errorWidget: (context, url, error) =>
            //                 const Icon(Icons.error, color: Colors.red),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 10, vertical: 10),
            //             child: Text(
            //               "${following['username']} : ${latestPosts['caption'] ?? 'nothing in caption'}",
            //             ),
            //           ),
            //           Padding(
            //             padding: EdgeInsets.only(
            //                 left: mediaQuery.screenWidth * 0.03),
            //             child: Align(
            //               alignment: Alignment.bottomLeft,
            //               child: Text(
            //                 latestPosts['date'],
            //                 style: TextStyle(
            //                   fontSize: mediaQuery.screenWidth * 0.025,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Row(
            //                 children: [
            //                   LikeButton(
            //                     onPressed: () {
            //                       likeProvider.toggleLike(
            //                           userId, latestPosts['id']);
            //                     },
            //                     isLiked:
            //                         likeProvider.isLiked(latestPosts['id']),
            //                   ),
            //                   Text(likeProvider
            //                       .likeCount(latestPosts['id'])
            //                       .toString()),
            //                 ],
            //               ),
            //               Consumer<SavePostProvider>(
            //                 builder: (context, savedPostProvider, child) {
            //                   return IconButton(
            //                     icon: Icon(
            //                       savedPostProvider.savedPosts.any((post) =>
            //                               post['id'] == latestPosts['id'])
            //                           ? Icons.bookmark
            //                           : Icons.bookmark_border,
            //                       color: savedPostProvider.savedPosts.any(
            //                               (post) =>
            //                                   post['id'] == latestPosts['id'])
            //                           ? Colors.black
            //                           : null,
            //                     ),
            //                     onPressed: () {
            //                       savedPostProvider.togglePostToSave(
            //                         latestPosts['id'],
            //                         userId,
            //                         latestPosts,
            //                       );
            //                       showCustomSnackBar(
            //                         context,
            //                         Icons.bookmark_added,
            //                         "You've Saved ${following['username']} post",
            //                         1,
            //                       );
            //                     },
            //                   );
            //                 },
            //               ),
            //             ],
            //           ),
            //         ],
            //       ],
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }
}

void showCustomSnackBar(
    BuildContext context, IconData icon, String text, int sec) {
  final mediaQuery = MediaQueryHelper(context);

  ScaffoldMessenger.of(context).showSnackBar(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: Duration(seconds: sec),
    ),
  );
}
