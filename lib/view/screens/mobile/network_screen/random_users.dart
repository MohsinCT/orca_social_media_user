import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/navigation_provider.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_grid_view_shimmer.dart';
import 'package:provider/provider.dart';

class RandomUsers extends StatelessWidget {
  const RandomUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context , listen:  false);
    final currentUser = userProvider.getLoggedUserId();
    final navigatorProvider = Provider.of<NavigationProvider>(context , listen:  false);
    return ChangeNotifierProvider(
      create: (context) => UserProvider()..fetchAndSetUsers(),
      child: Consumer<UserProvider>(
        builder: (context, rondomPProvider, child) {
          final randomPeople = rondomPProvider.allUsers;
          final randomUsers = randomPeople.skip(5).toList();

          if(randomPeople.isEmpty){
            return GridVieShimmer();
          }
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.screenWidth * 0.04),
            child: SizedBox(
              height: mediaQuery.screenHeight * 0.5,
              child: GridView.builder(
                itemCount: randomUsers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: mediaQuery.screenWidth * 0.04,
                  mainAxisSpacing: mediaQuery.screenHeight * 0.02,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final userR = randomUsers[index];
                  return GestureDetector(
                    onTap: () => 
                    userR.id == currentUser ? navigatorProvider.setCurrentIndex(3):
                     Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserProfile(
                              userId: userR.id,
                            ))),
                    child: userR.id == currentUser ? 
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                  child: CachedNetworkImage(
                                imageUrl: userR.profilPicture,
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ))),
                          SizedBox(
                            height: mediaQuery.screenHeight * 0.02,
                          ),
                          Text(userR.username),
                          SizedBox(
                            height: mediaQuery.screenHeight * 0.02,
                          ),
                          Text('You',style:TextStyle(color: Colors.grey),)
                        ],
                      ),
                    ) :
                     Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                  child: CachedNetworkImage(
                                imageUrl: userR.profilPicture,
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ))),
                          SizedBox(
                            height: mediaQuery.screenHeight * 0.02,
                          ),
                          Text(userR.username),
                          SizedBox(
                            height: mediaQuery.screenHeight * 0.02,
                          ),
                          FollowButton(
                            userId: userR.id,
                            
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
