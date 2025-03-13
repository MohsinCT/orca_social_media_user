import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SavePostProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String? errorMessage;

  List<Map<String , dynamic>> _savedPosts = [];
  List<Map<String , dynamic>> get savedPosts => _savedPosts;

  Future<void> togglePostToSave(String postId , String userId , Map<String , dynamic> postData , ) async{
    try{
      final docRef = _firestore.collection('users').doc(userId).collection('savedPosts').doc(postId);
      final doc = await docRef.get();

      if(doc.exists){
        await docRef.delete();
        _savedPosts.removeWhere((post) => post['id'] == postId );
        log('post removed');
      } else {
        await docRef.set(postData);
        _savedPosts.add(postData);
        log('post saved');

      }
      notifyListeners();

    }catch(e){
      log("Error saving post:$e");

    }
  }

  Future<void> fetchBookmarkedPosts(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _firestore.collection('users').doc(userId).collection('bookmarks').get();
      _savedPosts = snapshot.docs.map((doc) => doc.data()).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Error loading bookmarks";
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> toggleSavePost(String userId, String postId) async {
  //   final userRef = _firestore.collection('users').doc(userId);
  //   final savedPostsRef = userRef.collection('savedPosts');

  //   final savedPost = await savedPostsRef.doc(postId).get();

  //   if (savedPost.exists) {
  //     // If the post is already saved, remove it
  //     await savedPostsRef.doc(postId).delete();
  //   } else {
  //     // Otherwise, save the post
  //     await savedPostsRef.doc(postId).set({
  //       'postId': postId,
  //       'savedAt': FieldValue.serverTimestamp(),
  //     });
  //   }

  //   notifyListeners();
  // }

  // Stream<List<String>> getSavedPostIds(String userId) {
  //   return _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('savedPosts')
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  // }
}


