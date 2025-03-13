import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/follow_button_controller.dart';
import 'package:orca_social_media/controllers/navigation_provider.dart';
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? currentUser = userProvider.getLoggedUserId();
    final navigatorProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..fetchAndSetUsers(),
      child: Consumer2<UserProvider, FollowProvider>(
        builder: (context, userProvider, followProvider, child) {
          final users = userProvider.allUsers;
          final justlandedUsers = users.take(5).toList();

          if (users.isEmpty) {
            return ListviewShimmer();
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: justlandedUsers.length,
            itemBuilder: (context, index) {
              final user = justlandedUsers[index];
              if (user.id == currentUser) {
                return GestureDetector(
                  onTap: () {
                    user.id == currentUser
                        ? navigatorProvider.setCurrentIndex(3)
                        : Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(userId: user.id)));
                  },
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: user.profilPicture,
                                    imageBuilder: (context, imageProvider) =>
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
                                    horizontal: mediaQuery.screenWidth * 0.08),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: mediaQuery.screenWidth * 0.1,
                                    ),
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                          fontSize:
                                              mediaQuery.screenWidth * 0.04),
                                    ),
                                    SizedBox(
                                      height: mediaQuery.screenHeight * 0.01,
                                    ),
                                    Text(
                                      'You',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.orGrey),
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
              }

              // bool isFollowing = followProvider.isFollowing(user.id);
              // print(' user id ${user.id}');
              // bool followsBack = .contains(user.id);

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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.profilPicture,
                                  imageBuilder: (context, imageProvider) =>
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
                                  horizontal: mediaQuery.screenWidth * 0.08),
                              child: Column(children: [
                                SizedBox(
                                  width: mediaQuery.screenWidth * 0.1,
                                ),
                                Text(
                                  user.username,
                                  style: TextStyle(
                                      fontSize: mediaQuery.screenWidth * 0.04),
                                ),
                                SizedBox(
                                  height: mediaQuery.screenHeight * 0.01,
                                ),
                                FollowButton(
                                  userId: user.id,
                                  username: user.username,
                                )
                              ]),
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
        },
      ),
    );
  }
}
