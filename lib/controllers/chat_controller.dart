// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:orca_social_media/models/messages_model.dart';

// class ChatControllerProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Message> _messages = [];
//   List<Message> get messages => _messages;

//   Future<void> fetchMessages(String chatId) async {
//     _firestore
//         .collection('messages')
//         .doc(chatId)
//         .collection('chats')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       _messages = snapshot.docs
//           .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
//           .toList();
//       notifyListeners();
//     });
//   }

//   Future<void> sendMessage(String chatId, String text, String senderId) async {
//     final message = Message(
//       text: text,
//       senderId: senderId,
//       timestamp: DateTime.now(),
//       isRead: false,
//     );

//     await _firestore
//         .collection('messages')
//         .doc(chatId)
//         .collection('chats')
//         .add(message.toMap());
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:orca_social_media/models/messages_model.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late ChatUser me;
  static User get user => auth.currentUser!;

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
         .orderBy('sent', descending:true )
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg , Type type) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: '',
        type: type,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending:true )
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser , File file )async{
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('chatImages/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
      log('Data transferred : ${p0.bytesTransferred/1000}kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await APIs.sendMessage(chatUser, imageUrl ,Type.image );
  }
}
