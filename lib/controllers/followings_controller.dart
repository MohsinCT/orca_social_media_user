import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orca_social_media/models/post_model.dart';

class FollowingsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _allFollowings = [];
  List<Map<String, dynamic>> _filteredFollowings = [];
  bool _isLoading = false;
 
  List<Map<String, dynamic>> get allFollowings => _allFollowings;
  List<Map<String, dynamic>> get filteredFollowings => _filteredFollowings;
  bool get isLoading => _isLoading;

  Future<void> fetchFollowings(String userId) async {
    _isLoading = true;
    notifyListeners();
 
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    final List<dynamic> followingsIds = userDoc.data()?['followings'] ?? [];

    List<Map<String, dynamic>> followingsData = [];
    for (String followingsId in followingsIds) {
      final followingsDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(followingsId)
          .get();
      if (followingsDoc.exists) {
        followingsData.add(followingsDoc.data()!);
      }
    }

    _allFollowings = followingsData;
    _filteredFollowings = followingsData;
    _isLoading = false;
    notifyListeners();
  }

  Future<List<PostModel>> fetchFollowingsPosts(String currentUserId) async {
  List<PostModel> followingsPosts = [];

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    final List<dynamic> followingsIds = userDoc.data()?['followings'] ?? [];

    if (followingsIds.isEmpty) return [];

    for (String followingsId in followingsIds) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(followingsId)
          .collection('posts')
          .orderBy('date', descending: true)
          .get();

      followingsPosts.addAll(
        querySnapshot.docs.map((doc) {
          return PostModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList(),
      );
    }
  } catch (e) {
    debugPrint('Error fetching followings posts: $e');
  }

  return followingsPosts;
}

  void filterFollowings(String query) {
    if (query.isEmpty) {
      _filteredFollowings = _allFollowings;
    } else {
      _filteredFollowings = _allFollowings
          .where((following) =>
              (following['username'] ?? '').toLowerCase().contains(query))
              
          .toList();
    }
    notifyListeners();
  }
}
