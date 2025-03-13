import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/users_story_controller.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/story_screen.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/users_story_screen.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_story_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StoryCircle extends StatelessWidget {
  final String userId;

  const StoryCircle({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FollowingsController()..fetchFollowings(userId)),
        ChangeNotifierProvider(
            create: (_) => UserProvider()..fetchUserDetails()),
      ],
      child: Consumer2<FollowingsController, UserProvider>(
        builder: (context, followingsProvider, userProvider, child) {
          if (followingsProvider.isLoading) {
            return StoryShimmer();
          }

          final followings = followingsProvider.followings;

          return SizedBox(
            height: mediaQuery.screenHeight * 0.15,
            child: ListView.builder(
              itemCount: followings.length + 1, // +1 for current user story
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Current User Story
                  return Padding(
                    padding:
                        EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => StoryScreen(userId: userId),
                            ));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              FutureBuilder<UserModel?>(
                                future: userProvider.fetchUserDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: AppColors.oRLightGrey
                                          .withOpacity(0.5),
                                      highlightColor:
                                          Colors.white.withOpacity(0.3),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width:
                                                mediaQuery.screenWidth * 0.22,
                                            height:
                                                mediaQuery.screenHeight * 0.1,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.oRLightGrey,
                                            ),
                                          ),
                                          if (index == 0)
                                            Positioned(
                                              right:
                                                  mediaQuery.screenWidth * 0.01,
                                              bottom: mediaQuery.screenHeight *
                                                  0.01,
                                              child: Container(
                                                width: mediaQuery.screenWidth *
                                                    0.06,
                                                height: mediaQuery.screenWidth *
                                                    0.06,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.oRBlack,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Errror und........'),
                                    );
                                  } else {
                                    final user = snapshot.data!;
                                    return Container(
                                      width: mediaQuery.screenWidth * 0.22,
                                      height: mediaQuery.screenHeight * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            user.profilPicture,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // ignore: unnecessary_null_comparison
                                      child: user.profilPicture == null ||
                                              user.profilPicture.isEmpty
                                          ? Shimmer.fromColors(
                                              baseColor: AppColors.oRLightGrey
                                                  // ignore: deprecated_member_use
                                                  .withOpacity(0.5),
                                              highlightColor:
                                                  // ignore: deprecated_member_use
                                                  Colors.white.withOpacity(0.3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.oRLightGrey,
                                                ),
                                              ),
                                            )
                                          : null, // No shimmer if the picture is available
                                    );
                                  }
                                },
                              ),
                              Positioned(
                                right: mediaQuery.screenWidth * 0.01,
                                bottom: mediaQuery.screenHeight * 0.01,
                                child: Container(
                                  width: mediaQuery.screenWidth * 0.06,
                                  height: mediaQuery.screenWidth * 0.06,
                                  decoration: const BoxDecoration(
                                    color: AppColors.oRBlack,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: mediaQuery.screenHeight * 0.01),
                        const Text(
                          'Your Story',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Other Users' Stories
                  final following = followings[index - 1];
                  return Padding(
                    padding:
                        EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UsersStories(userId: following['id']),
                            ));
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                width: mediaQuery.screenWidth * 0.22,
                                height: mediaQuery.screenHeight * 0.1,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      following['profilePicture'] ?? '',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: mediaQuery.screenHeight * 0.01),
                        Text(
                          following['username'] ?? 'Unknown',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
