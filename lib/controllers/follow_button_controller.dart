import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map to store follow state for users (key: userId, value: isFollowed)
  final Map<String, bool> _followState = {};

  // Check if the current user is following a specific user
  bool isFollowing(String userId) {
    return _followState[userId] ?? false;
  }

  // Toggle follow/unfollow and update backend
  Future<void> toggleFollow(String userId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return; // Handle unauthenticated user
    }

    final isFollow = !isFollowing(userId); // Toggle follow state locally
    _followState[userId] = isFollow;
    notifyListeners();

    try {
      if (isFollow) {
        // Add to following and increment follower count
        await _firestore.collection('users').doc(currentUser.uid).update({
          'following': FieldValue.arrayUnion([userId]),
        });
        await _firestore.collection('users').doc(userId).update({
          'followersCount': FieldValue.increment(1),
        });
      } else {
        // Remove from following and decrement follower count
        await _firestore.collection('users').doc(currentUser.uid).update({
          'following': FieldValue.arrayRemove([userId]),
        });
        await _firestore.collection('users').doc(userId).update({
          'followersCount': FieldValue.increment(-1),
        });
      }
    } catch (e) {
      // Revert state if backend operation fails
      _followState[userId] = !isFollow;
      notifyListeners();
      throw Exception('Failed to toggle follow state: $e');
    }
  }
}
