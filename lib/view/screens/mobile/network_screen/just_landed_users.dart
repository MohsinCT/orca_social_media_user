import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_listview_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class JustLandedUsers extends StatelessWidget {
  const JustLandedUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..fetchAndSetUsers(),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final users = userProvider.allUsers;
          final justlandedUsers = users.take(5).toList();

          return FutureBuilder(
            future: userProvider.fetchAllUsers(), // Fetch users only once
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListviewShimmer();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: justlandedUsers.length,
                  itemBuilder: (context, index) {
                    final user = justlandedUsers[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfile(
                                userId: user.id,
                              ))),
                      child: Container(
                        width: mediaQuery.screenWidth * 0.74,
                        margin: EdgeInsets.symmetric(
                            horizontal: mediaQuery.screenWidth * 0.01),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 225, 225),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: user.profilPicture,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey[200],
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              AssetImage(AppImages.orcalogo),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            mediaQuery.screenWidth * 0.08),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: mediaQuery.screenWidth * 0.1,
                                        ),
                                        Text(
                                          user.username,
                                          style: TextStyle(
                                              fontSize: mediaQuery.screenWidth *
                                                  0.04),
                                        ),
                                        SizedBox(
                                          height:
                                              mediaQuery.screenHeight * 0.01,
                                        ),
                                        FollowButton(
                                          userId: user.id,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('Some error occurred'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
