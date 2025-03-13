import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/chat_controller.dart';
import 'package:orca_social_media/models/messages_model.dart';

class FollowingsController extends ChangeNotifier{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User get user => auth.currentUser!;
  bool _isLoading = false;
  List<Map<String, dynamic>> _followings = [];
  

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get followings => _followings;

  Future<void> fetchFollowings(String userId) async {
    if (_isLoading) return; // Avoid multiple fetches

    _isLoading = true;
    notifyListeners();

    try {
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

      _followings = followingsData;
    } catch (error) {
      print('Error fetching followings: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
 
 String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';


  Stream<QuerySnapshot<Map<String , dynamic>>> getLastMessage(ChatUser user){
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending:true )
        .limit(1)
        .snapshots();
    
  }
  Future<void> markMessageAsRead(String conversationId, String messageId) async {
  try {
    await firestore
        .collection('chats/$conversationId/messages')
        .doc(messageId)
        .update({
      'read': FieldValue.arrayUnion([user.uid]),
    });
    notifyListeners();
  } catch (e) {
    print("Error updating read status: $e");
  }
}

void updateMessageReadStatus(Message message) {
    if (message.read!.isEmpty) {
      APIs.updateMessageReadStatus(message);
      log('message read updated');
      notifyListeners();
    }
  }

}