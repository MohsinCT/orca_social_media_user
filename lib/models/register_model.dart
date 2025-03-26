import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String profilPicture;
  final String bio;
  final String nickname;
  final String location;
  final String date;
  int postCount;
  final dynamic timestamp;
  final bool isOnline;
  final int followersCount;
  final int followingCount;
  final List<String> followers;
  final List<String> followings;
  final bool isDisabled;
  final List<String> likedUser;
  final int likesCount;
  final int unreadNotification; // New field added

  UserModel({
    required this.id,
    required this.isOnline,
    required this.username,
    required this.email,
    required this.password,
    required this.profilPicture,
    required this.bio,
    required this.nickname,
    required this.location,
    required this.date,
    required this.timestamp,
    required this.postCount,
    required this.followingCount,
    required this.followersCount,
    required this.followers,
    required this.followings,
    required this.isDisabled,
    required this.likedUser,
    required this.likesCount,
    required this.unreadNotification, // Added in constructor
  });

  // Convert the model to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'profilePicture': profilPicture,
      'bio': bio,
      'nickname': nickname,
      'location': location,
      'date': date,
      'postCount': postCount,
      'timestamp': timestamp,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'followers': followers,
      'followings': followings,
      'isOnline': isOnline,
      'isDisabled': isDisabled,
      'likedUser': likedUser,
      'likesCount': likesCount,
      'unreadNotification': unreadNotification, // Added in toMap
    };
  } 

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilPicture: map['profilePicture'] ?? '',
      bio: map['bio'] ?? '',
      nickname: map['nickname'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      postCount: map['postCount'] ?? 0,
      timestamp: map['timestamp'],
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      followers: List.from(map['followers'] ?? []),
      followings: List.from(map['followings'] ?? []),
      isOnline: map['isOnline'] ?? false,
      isDisabled: map['isDisabled'] ?? false,
      likedUser: List.from(map['likedUser'] ?? []),
      likesCount: map['likesCount'] ?? 0,
      unreadNotification: map['unreadNotification'] ?? 0, // Added in fromMap
    );
  }

  // Create a UserModel from a Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc['id'] ?? '',
      isOnline: doc['isOnline'] ?? false,
      username: doc['username'] ?? '',
      email: doc['email'] ?? '',
      password: doc['password'] ?? '',
      profilPicture: doc['profilePicture'] ?? '',
      bio: doc['bio'] ?? '',
      nickname: doc['nickname'] ?? '',
      location: doc['location'] ?? '',
      date: doc['date'] ?? '',
      timestamp: doc['timestamp'],
      postCount: doc['postCount'] ?? 0,
      followingCount: doc['followingCount'] ?? 0,
      followersCount: doc['followersCount'] ?? 0,
      followers: List.from(doc['followers'] ?? []),
      followings: List.from(doc['followings'] ?? []),
      isDisabled: doc['isDisabled'] ?? false,
      likedUser: List.from(doc['likedUser'] ?? []),
      likesCount: doc['likesCount'] ?? 0,
      unreadNotification: doc['unreadNotification'] ?? 0, // Added in fromDocument
    );
  }
}
