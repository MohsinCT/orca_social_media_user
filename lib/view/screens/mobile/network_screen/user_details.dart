import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_user_shimmer.dart';
import 'package:orca_social_media/view/widgets/mobile/users_details.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  final String userId;

  UserProfile({
    super.key,
    required this.userId,
  });

  final List<String> tabNames = [
    'Posts',
    'Liked',
  ];

  Future<void> _handleRefresh(BuildContext context) async {
   Provider.of<UserProvider>(context, listen: false);
 
}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: CustomAppbar(
          automaticallyImplyleading: true,
          title: FutureBuilder<UserModel>(
            future: userProvider.fetchUserById(userId), 
            builder: (context , snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return LinearProgressIndicator();
              } else if (snapshot.hasError || snapshot.data == null){
                return Text('Orca user');
              }
              final user = snapshot.data!;
              return Text(user.username);
            }),
            actions: [
              IconButton(onPressed: (){

              }, icon: Icon(Icons.more_vert))
            ],
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
                                  userImage: user.profilPicture,
                                  nickname: user.nickname == 'Add nickname'
                                      ? '--'
                                      : user.nickname,
                                  bio: user.bio == 'Add Bio' ? '--' : user.bio,
                                  location: user.location == 'Add location'
                                      ? 'Not added'
                                      : user.location,
                                  date: user.date,
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
                                GridView.builder(
                                  padding: const EdgeInsets.all(10),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // Number of items in a row
                                    mainAxisSpacing:
                                        10.0, // Vertical space between grid items
                                    crossAxisSpacing:
                                        4.0, // Horizontal space between grid items
                                    childAspectRatio:
                                        1.0, // Aspect ratio of each item
                                  ),
                                  // Disable GridView scrolling
                                  shrinkWrap:
                                      true, // Make GridView take only the necessary height
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.asset(
                                        'assets/Credit card.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                  itemCount:
                                      9, // Set the total number of items here
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



