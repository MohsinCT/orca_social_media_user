import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => SplashProvider(context),
        child: Consumer<SplashProvider>(
          builder: (context, splashProvider, child) {
            final controller = splashProvider.controller;
        
            if (controller.value.isInitialized) {
              final videoAspectRatio = controller.value.aspectRatio;
        
              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: mediaQuery.screenWidth,
                    height: mediaQuery.screenWidth / videoAspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
