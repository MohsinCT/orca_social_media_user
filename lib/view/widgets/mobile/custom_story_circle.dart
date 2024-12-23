import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/story_screen.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/users_story_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class StoryCircle extends StatelessWidget {
  StoryCircle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvier = Provider.of<UserProvider>(context, listen: false);
    String? currentUser = userProvier.getLoggedUserId();

    return SizedBox(
      height: mediaQuery.screenHeight * 0.15,
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          Provider.of<UserProvider>(context, listen: false).fetchUserDetails(),
          Provider.of<UserProvider>(context, listen: false).fetchAllUsers(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading...'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Stories'),
            );
          }

          final userData = snapshot.data![0] as UserModel;
          final allUsers = snapshot.data![1] as List<UserModel>;

          return ListView.builder(
            itemCount: allUsers.length, // +1 for the current user story
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Display the current user's story
                return Padding(
                  padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => StoryScreen(
                                    userId: currentUser,
                                  )));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: mediaQuery.screenWidth * 0.22,
                              height: mediaQuery.screenHeight * 0.1,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.oRLightGrey,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          userData.profilPicture),
                                      fit: BoxFit.cover)),
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
                      SizedBox(
                        height: mediaQuery.screenHeight * 0.01,
                      ),
                      Text(
                        'Your Story', // Display the current user's name
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                // Display all other users' stories
                final allusers = allUsers[index];
                return Padding(
                  padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UsersStories(userId: allusers.id,)));
                        },
                        child: Container(
                          width: mediaQuery.screenWidth * 0.22,
                          height: mediaQuery.screenHeight * 0.1,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.oRBlack,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    allusers.profilPicture),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.screenHeight * 0.01,
                      ),
                      Text(
                        allusers.username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
