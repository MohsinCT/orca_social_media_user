import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map to store follow state for users (key: userId, value: isFollowed)
  final Map<String, bool> _followState = {};
  final Map<String , bool> _loadingState = {};

  bool isLoading(String userId) => _loadingState[userId] ?? false;

  // Check if the current user is following a specific user
  bool isFollowing(String userId) {
    return _followState[userId] ?? false;
  }
   
  // Follow a user
  Future<void> followUser(String targetUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final currentUserId = currentUser.uid;

    try {
      // Update local state
      _followState[targetUserId] = true;
      notifyListeners();

      // Update Firestore
      await _firestore.runTransaction((transaction) async {
        final currentUserDoc = _firestore.collection('users').doc(currentUserId);
        final targetUserDoc = _firestore.collection('users').doc(targetUserId);

        // Update current user's followings
        transaction.update(currentUserDoc, {
          'followings': FieldValue.arrayUnion([targetUserId]),
          'followingCount': FieldValue.increment(1),
        });

        // Update target user's followers
        transaction.update(targetUserDoc, {
          'followers': FieldValue.arrayUnion([currentUserId]),
          'followersCount': FieldValue.increment(1),
        });
      });
    } catch (e) {
      // Revert state if backend operation fails
      _followState[targetUserId] = false;
      notifyListeners();
      throw Exception('Failed to follow user: $e');
    }
  }

  // Unfollow a user
  Future<void> unfollowUser(String targetUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final currentUserId = currentUser.uid;

    try {
      // Update local state
      _followState[targetUserId] = false;
      notifyListeners();

      // Update Firestore
      await _firestore.runTransaction((transaction) async {
        final currentUserDoc = _firestore.collection('users').doc(currentUserId);
        final targetUserDoc = _firestore.collection('users').doc(targetUserId);

        // Update current user's followings
        transaction.update(currentUserDoc, {
          'followings': FieldValue.arrayRemove([targetUserId]),
          'followingCount': FieldValue.increment(-1),
        });

        // Update target user's followers
        transaction.update(targetUserDoc, {
          'followers': FieldValue.arrayRemove([currentUserId]),
          'followersCount': FieldValue.increment(-1),
        });
      });
    } catch (e) {
      // Revert state if backend operation fails
      _followState[targetUserId] = true;
      notifyListeners();
      throw Exception('Failed to unfollow user: $e');
    }
  }

  Future<void> fetchFollowState(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;
    try {
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();
      final followings = List<String>.from(userDoc.data()?['followings'] ?? []);
      _followState[userId] = followings.contains(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch follow state: $e');
    }
  }


Future<void> initFollowState(String userId) async {
    await fetchFollowState(userId);
  }
 

  // Toggle follow/unfollow state
  Future<void> toggleFollow(String targetUserId) async {
    if (_loadingState[targetUserId] == true) return; // Prevent multiple taps
    _loadingState[targetUserId] = true;
    notifyListeners();

    try {
      if (isFollowing(targetUserId)) {
        await unfollowUser(targetUserId);
      } else {
        await followUser(targetUserId);
      }
    } catch (e) {
      debugPrint('Error toggling follow: $e');
    } finally {
      _loadingState[targetUserId] = false;
      notifyListeners();
    }
  }
}
