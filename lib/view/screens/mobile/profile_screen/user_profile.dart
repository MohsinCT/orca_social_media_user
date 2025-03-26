import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/counter.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/add_story.dart';
import 'package:orca_social_media/view/screens/mobile/post_screen/post_screen.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/settings/settings_screen.dart';

import 'package:orca_social_media/view/screens/mobile/profile_screen/user_post_show_dialog.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/user_posts.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_user_details.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<String> tabNames = ['Posts', 'Liked'];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? currentUser = userProvider.getLoggedUserId();

    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: CustomAppbar(
          title: Text('Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => PostDialog(
                          sharePost: 'Share post',
                          shareMessage: 'Share message',
                          shareStory: 'Share story',
                          sharePosts: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => PostScreen(
                                          userId: currentUser,
                                        )))
                                .then(Navigator.of(context).pop);
                          },
                          shareMessages: () {},
                          shareStories: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => StoryAddingPage(
                                      userId: currentUser,
                                    )));
                          }));
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen()));
                },
                icon: Icon(Icons.menu))
          ],
        ),
        body: Consumer2<UserProvider , CounterProvider>(builder: (context, value,counter, child) {
          return LiquidPullToRefresh(
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
                            horizontal: mediaQuery.screenWidth * 0.05,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const UserDetails(),
                              TabBar(
                                tabs: tabNames
                                    .map((tab) => Tab(text: tab))
                                    .toList(),
                              ),
                              SizedBox(
                                height: mediaQuery.screenHeight * 0.73,
                                child: TabBarView(
                                  children: [
                                    // First Tab: Posts
                                    UserPosts(),
                                    // Second Tab: Messages (Placeholder)

                                    // Third Tab: Liked Posts (Placeholder)
                                    Center(
                                      child: Text('No Liked Posts'),
                                    ),
                                  ],
                                ),
                              ),
                            ], 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Future<void> _handleRefresh(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final postCount  = Provider.of<CounterProvider>(context , listen:  false);
  await userProvider.refresh();
  await postCount.refresh();
}
