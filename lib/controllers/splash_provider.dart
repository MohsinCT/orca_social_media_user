import 'dart:async';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/bottom_nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/get_started.dart';

class SplashProvider with ChangeNotifier {
  late VideoPlayerController _controller;

  SplashProvider(BuildContext context) {
    _controller = VideoPlayerController.asset('assets/orca_splash_video.mp4')
      ..initialize().then((_) {
        notifyListeners(); // Notify listeners once the video is initialized
        _controller.play(); // Automatically play the video

        // Schedule navigation after 4 seconds
        Timer(const Duration(seconds: 4), () {
          _navigateToNextPage(context);
        });
      });
  }

  VideoPlayerController get controller => _controller;

  // Make _navigateToNextPage async to wait for login status
  Future<void> _navigateToNextPage(BuildContext context) async {
    if (context.mounted) {
      bool isLoggedIn = await getLoginStatus(); // Wait for login status

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  BottomNavScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GetStarted()),
        );
      }
    }
  }

  // Update getLoginStatus to return a Future<bool>
  Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('isLoggedIn');  // Fetch the login status

    bool _isLoggedIn = status ?? false; // Use false as default if null
    print('Login Status Fetched: $_isLoggedIn');
    return _isLoggedIn;
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the video controller when the provider is disposed
    super.dispose();
  }
}
