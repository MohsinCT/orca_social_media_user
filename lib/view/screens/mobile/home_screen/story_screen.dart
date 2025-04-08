import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/story_controller.dart';
import 'package:orca_social_media/controllers/story_state_controller.dart';
import 'package:orca_social_media/models/story_model.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatelessWidget {
  final String? userId;
  const StoryScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    Provider.of<StoryProvider>(context, listen: false).loadStories(userId!);
    final mediaQuery = MediaQueryHelper(context);
    // final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => StoryStateController(
              TickerProviderStateMixinImplementation(), context),
          child: Consumer2<StoryStateController, StoryProvider>(
            builder: (context, storyStsProvider, storyProvider, child) {
              final stories = storyProvider.stories;

              if (stories.isEmpty) {}

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

                      ListTile(
                        trailing: IconButton(
                            onPressed: () async {
                              await storyProvider.deleteStory(
                                  userId: userId!,
                                  storyId: story.id,
                                  imageUrl: story.image,
                                  context: context);
                              Navigator.of(context).pop();
                            },
                            icon: storyProvider.isLoading == true
                                ? CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
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

class TickerProviderStateMixinImplementation extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
