// import 'package:flutter/material.dart';
// import 'package:orca_social_media/controllers/like_controller.dart';
// import 'package:provider/provider.dart';

// class LikeButton extends StatelessWidget {
//   final String postId;
//   final String postOwnerId;
//   const LikeButton(
//       {super.key, required this.postId, required this.postOwnerId});

//   @override
//   Widget build(BuildContext context) {
//     final likeProvider = Provider.of<LikeProvider>(context, listen: false);

//     likeProvider.initLikeState(postId, postOwnerId);

//     return Consumer<LikeProvider>(
//       builder: (context, likeProvider, child) {
//         bool isLiked = likeProvider.isLiked(postId);
//         return IconButton(
//             onPressed: () async {
//               try {
//                 await likeProvider.toggleLike(postId, postOwnerId);
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error on liking: $e')),
//                 );
//               }
//             },
//             icon: Icon(
//               isLiked ? Icons.favorite : Icons.favorite_border,
//               color: isLiked ? Colors.red : Colors.black,
//             ));
//       },
//     );
//   }
// } 
 
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onPressed;
   LikeButton({super.key, required this.onPressed, required this.isLiked });

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, 
    icon: Icon(
      isLiked ? Icons.favorite : Icons.favorite_border,
      color: isLiked ? Colors.red : Colors.grey,
    )
    );
  }
}
