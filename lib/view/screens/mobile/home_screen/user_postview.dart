

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/post_model.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return FutureBuilder<List<dynamic>>(
      future:Future.wait([
        Provider.of<UserProvider>(context , listen:  false).fetchUserDetails(),
        Provider.of<UserProvider>(context , listen:  false).fetchPosts()
      ]),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();

        } else if(snapshot.hasError){
          return Center(child: Text('Error ${snapshot.error}'),);
        } else if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text('No posts Available'),);
        }
        final userData = snapshot.data![0] as UserModel;
        final posts = snapshot.data! [1] as List<PostModel>;
        return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: mediaQuery.screenHeight * 0.02,
            ),
            child: Container(
              width: mediaQuery.screenWidth,
              color: AppColors.oRLightGrey,
              child: Column(
                children: [
                  ListTile(
                    leading:  CircleAvatar(
                      backgroundImage: NetworkImage(userData.profilPicture),
                    ),
                    title: Text(
                      userData.username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.more_vert),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.screenWidth * 0.0,
                    ),
                    child: SizedBox(
                      width: mediaQuery.screenWidth,
                      height: mediaQuery.screenHeight * 0.4,
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
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text("${userData.username} : ${post.caption}"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                    child:  Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(post.date ,style: TextStyle(
                          fontSize: mediaQuery.screenWidth * 0.025 ,
                          color: Colors.grey
                        ),)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // Handle like button press
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          // Handle comment button press
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Handle share button press
                        },
                      ),
                      SizedBox(width: mediaQuery.screenWidth * 0.45),
                      IconButton(
                        icon: const Icon(Icons.bookmark_add_outlined),
                        onPressed: () {
                          // Handle bookmark button press
                        },
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
