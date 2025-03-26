import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, bool> _likedPosts = {}; // Track each post's like state
  Map<String, int> _likeCounts = {}; // Track each post's like count

  bool isLiked(String postID) => _likedPosts[postID] ?? false;
  int likeCount(String postID) => _likeCounts[postID] ?? 0;

  Future<void> setInitialLikeStatus(String userID, String postID) async {
    final currentUserEmail = _auth.currentUser!.email;

    final QuerySnapshot postSnapshot = await _firestore
        .collection("users")
        .doc(userID)
        .collection("posts")
        .where('id', isEqualTo: postID)
        .limit(1)
        .get();

    if (postSnapshot.docs.isNotEmpty) {
      final postData = postSnapshot.docs.first.data() as Map<String, dynamic>;

      List<String> likedUsers = List<String>.from(postData['likedUsers'] ?? []);

      _likedPosts[postID] = likedUsers.contains(currentUserEmail);
      _likeCounts[postID] = likedUsers.length;
    } else {
      _likedPosts[postID] = false;
      _likeCounts[postID] = 0;
    }

    notifyListeners();
  }

  Future<void> toggleLike(String userID, String postID) async {
    final currentUserEmail = _auth.currentUser!.email;

    final QuerySnapshot postSnapshot = await _firestore
        .collection("users")
        .doc(userID)
        .collection("posts")
        .where('id', isEqualTo: postID)
        .limit(1)
        .get();

    if (postSnapshot.docs.isNotEmpty) {
      final DocumentReference postRef = postSnapshot.docs.first.reference;

      if (_likedPosts[postID] == true) {
        await postRef.update({
          'likedUsers': FieldValue.arrayRemove([currentUserEmail])
        });
        _likeCounts[postID] = (_likeCounts[postID] ?? 1) - 1;
      } else {
        await postRef.update({
          'likedUsers': FieldValue.arrayUnion([currentUserEmail])
        });
        _likeCounts[postID] = (_likeCounts[postID] ?? 0) + 1;
      }

      _likedPosts[postID] = !_likedPosts[postID]!;
      notifyListeners();
    } else {
      log("Post not found");
    }
  }
}

