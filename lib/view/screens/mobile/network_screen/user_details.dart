import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_post_screen.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_user_shimmer.dart';
import 'package:orca_social_media/view/widgets/mobile/users_details.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserProfile extends StatelessWidget {
  final String userId;

  UserProfile({
    super.key,
    required this.userId,
  });

  final List<String> tabNames = [
    'Posts',
  ];

  Future<void> _handleRefresh(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
     
    final currentUser =  userProvider.getLoggedUserId();

    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: CustomAppbar(
          automaticallyImplyleading: true,
          title: FutureBuilder<UserModel>(
              future: userProvider.fetchUserById(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Text('Orca user');
                }
                final user = snapshot.data!;
                return Text(user.username);
              }),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),
        body: LiquidPullToRefresh(
          color: AppColors.oRBlack,
          animSpeedFactor: 2,
          showChildOpacityTransition: false,
          onRefresh: () => _handleRefresh(context),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.screenWidth * 0.05),
                        child: Column(
                          children: [
                            FutureBuilder<UserModel>(
                              future: userProvider.fetchUserById(userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return UserProfileShimmer();
                                } else if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return Center(
                                    child: Text('User not found'),
                                  );
                                }
                                final user = snapshot.data!;
                                return UsersDetails(
                                  username: user.username,
                                  user: user,
                                  userId: user.id,
                                  followingCount: user.followingCount,
                                  followersCount: user.followersCount,
                                  userImage: user.profilPicture,
                                  nickname: user.nickname,
                                  bio: user.bio,
                                  location: user.location,
                                  date: user.date,
                                  postCount: user.postCount,
                                );
                              },
                            ),
                            TabBar(
                                tabs: tabNames
                                    .map((tab) => Tab(
                                          text: tab,
                                        ))
                                    .toList()),
                            SizedBox(
                              height: mediaQuery.screenHeight * 0.74,
                              child: TabBarView(children: [
                                FutureBuilder<List<dynamic>>(
                                  future: Future.wait({
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .fetchPostsByUserId(userId),
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .fetchUserById(userId),
                                  }),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text('No posts Available'),
                                      );
                                    }

                                    final posts = snapshot.data![0];
                                    final user = snapshot.data![1] as UserModel;
                                    return GridView.builder(
                                      padding: const EdgeInsets.all(10),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostPage(
                                                          userProfile: user
                                                              .profilPicture,
                                                          username:
                                                              user.username,
                                                          postedImage:
                                                              post.image,
                                                          usernameForcaption:
                                                              user.username,
                                                          caption: post.caption,
                                                          date: post.date,
                                                          postId: post.id,
                                                          userId: user.id,
                                                          likes: List<
                                                                  String>.from(
                                                              post.likedUsers),
                                                          onPressed: () {},
                                                          delete: () {}, 
                                                        
                                                          edit: () { },
                                                        )));

                                            // showDialog(
                                            //     context: context,
                                            //     builder: (_) =>
                                            //         PostDetailDialog(
                                            //             userProfile:
                                            //                 user.profilPicture,
                                            //             username: user.username,
                                            //             postedImage: post.image,
                                            //             usernameForcaption:
                                            //                 user.username,
                                            //             caption: post.caption,
                                            //             date: post.date,
                                            //             postId: post.id,
                                            //             userId: userId,
                                            //             likes: List<String>.from(user.likedUser),
                                            //             onPressed: (){},
                                            //             ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child:
                                             post.image.isNotEmpty
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: CachedNetworkImage(
                                                      imageUrl: post.image,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      placeholder: (context,
                                                              url) =>
                                                          Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          color: Colors.grey,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                        child: Icon(Icons.error,
                                                            color: Colors.red),
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
                                          ),
                                        );
                                      },
                                      itemCount: posts.length,
                                    );
                                  },
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
