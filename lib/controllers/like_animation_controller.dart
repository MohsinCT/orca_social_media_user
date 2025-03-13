import 'package:flutter/material.dart';

class LikeAnimationProvider extends ChangeNotifier{
  final Map<String, bool> _likedPosts = {};
  final Map<String, bool> _showHeartAnimations = {};

  bool isPostLiked(String postId) => _likedPosts[postId] ?? false;
  bool shouldShowHeartAnimation(String postId) => _showHeartAnimations[postId] ?? false;

  void toggleLike(String postId, String userId) {
    _likedPosts[postId] = !(_likedPosts[postId] ?? false);
    _showHeartAnimations[postId] = true;

    notifyListeners();

    Future.delayed(const Duration(milliseconds: 400), () {
      _showHeartAnimations[postId] = false;
      notifyListeners();
    });
  }
}