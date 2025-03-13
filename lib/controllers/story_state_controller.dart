import 'package:flutter/material.dart';

class StoryStateController with ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  StoryStateController(TickerProvider vsync, BuildContext context) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        notifyListeners();
      });

    // Add status listener to pop the screen when animation is complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop(); // Pop the current screen
      }
    });

    _controller.forward(); // Start the animation
  }

  // Dispose the controller to avoid memory leaks
  void disposeController() {
    _controller.dispose();
  }
}
