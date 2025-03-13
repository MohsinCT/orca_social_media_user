import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map to store like state for posts (key: postId, value: isLiked)
  final Map<String, bool> _likeState = {};

  // Check if the current user liked a specific post
  bool isLiked(String postId) {
    return _likeState[postId] ?? false;
  }

  // Like a post
  Future<void> likePost(String userId, String postId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final currentUserId = currentUser.uid;
    try {
      // Update local state
      _likeState[postId] = true;
      notifyListeners();

      // Update Firestore
      await _firestore.runTransaction((transaction) async {
        final postDoc = _firestore
            .collection('users')
            .doc(userId)
            .collection('posts')
            .doc(postId);

        transaction.update(postDoc, {
          'likedUser': FieldValue.arrayUnion([currentUserId]),
          'likesCount': FieldValue.increment(1),
        });
      });
    } catch (e) {
      _likeState[postId] = false;
      notifyListeners();
      throw Exception('Failed to like post: $e');
    }
  }

  // Unlike a post
  Future<void> unlikePost(String userId, String postId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final currentUserId = currentUser.uid;
    try {
      // Update local state
      _likeState[postId] = false;
      notifyListeners();

      // Update Firestore
      await _firestore.runTransaction((transaction) async {
        final postDoc = _firestore
            .collection('users')
            .doc(userId)
            .collection('posts')
            .doc(postId);

        transaction.update(postDoc, {
          'likedUser': FieldValue.arrayRemove([currentUserId]),
          'likesCount': FieldValue.increment(-1),
        });
      });
    } catch (e) {
      _likeState[postId] = true;
      notifyListeners();
      throw Exception('Failed to unlike post: $e');
    }
  }

  // Fetch like state from Firestore
  Future<void> fetchLikeState(String userId, String postId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;
    try {
      final postDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .doc(postId)
          .get();

      final likedUserList = List<String>.from(postDoc.data()?['likedUser'] ?? []);
      _likeState[postId] = likedUserList.contains(currentUserId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch like state: $e');
    }
  }

  // Initialize the like state for a post
  Future<void> initLikeState(String userId, String postId) async {
    await fetchLikeState(userId, postId);
  }

  // Toggle like/unlike state
  Future<void> toggleLike(String userId, String postId) async {
    if (isLiked(postId)) {
      await unlikePost(userId, postId);
    } else {
      await likePost(userId, postId);
    }
  }
}
