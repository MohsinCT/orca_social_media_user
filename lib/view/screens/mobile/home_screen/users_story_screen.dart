import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/story_controller.dart';
import 'package:orca_social_media/controllers/story_state_controller.dart';
import 'package:orca_social_media/models/story_model.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/story_screen.dart';
import 'package:provider/provider.dart';

class UsersStories extends StatelessWidget {
 final  String? userId;
  const UsersStories({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    Provider.of<StoryProvider>(context , listen: false).loadStories(userId!);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) =>
              StoryStateController(TickerProviderStateMixinImplementation(),context ),
          child: Consumer2<StoryStateController, StoryProvider>(
            builder: (context, storyStsProvider, storyProvider, child) {
              final stories = storyProvider.stories;

              if (stories.isEmpty) {
                return const Center(
                  child: Text('No stories on this user',style: TextStyle(
                    color: Colors.white
                  ),),
                );
              }
              return PageView.builder(
                itemCount: stories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  StoryModel story = stories[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Animated Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Stack(
                          children: [
                            // Background bar
                            Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            // Animated foreground bar
                            Container(
                              height: 4,
                              width: MediaQuery.of(context).size.width *
                                  storyStsProvider.animation.value,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // User Name
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: mediaQuery.screenWidth,
                        height: mediaQuery.screenHeight * 0.79,
                        child: CachedNetworkImage(
                          imageUrl: story.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Placeholder for the story content
                      Center(
                        child: Text(
                          story.caption,
                          // ignore: deprecated_member_use
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}