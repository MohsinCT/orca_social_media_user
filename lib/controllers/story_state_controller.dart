import 'package:flutter/material.dart';

class StoryStateController with ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  StoryStateController(TickerProvider vsync){
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 10),
      );

       _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        notifyListeners();
      });
    _controller.forward();
  }
}