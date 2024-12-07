import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orca_social_media/models/register_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  UserModel? get user => _user;

  File? _profileImage;
  File? get profileImage => _profileImage;

  Future<UserModel?> fetchUserDetails() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      log('Error fetching user credentials $e');
    }
  }

  //--------------------------------Add User ------------------------------------//

  Future<void> registerUser(
      {required String username,
      required String email,
      required String password,
      required File profilPicture}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String? dounloadImAGE = await uploadImage(profilPicture);

      UserModel user = UserModel(
          email: email,
          password: password,
          username: username,
          profilPicture: dounloadImAGE.toString(),
          nickname: 'Add nickname',
          bio: 'Add Bio',
          location: 'Add location',
          date: DateFormat('MMM,d,yyyy').format(DateTime.now()));

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to register user:$e');
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      // loading.value = true;
      String fileName = basename(image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      // loading.value = false;

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }

  //--------------------------------Edit User------------------------------------//

  Future<void> editUserProfile({
    required String? username,
    required String? bio,
    required String? nickname,
    required String? location,
    File? profilePicture,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        Map<String, dynamic> updatedData = {};

        // Update profile picture if provided
        if (profilePicture != null) {
          String? updatedImageUrl = await uploadImage(profilePicture);
          if (updatedImageUrl != null) {
            updatedData['profilPicture'] = updatedImageUrl;
          }
        }
        // Update other user details if provided
        if (username != null) updatedData['username'] = username;
        if (bio != null) updatedData['bio'] = bio;
        if (nickname != null) updatedData['nickname'] = nickname;
        if (location != null) updatedData['location'] = location;

        if (updatedData.isNotEmpty) {
          // Update the Firestore document for the current user
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .update(updatedData);
          notifyListeners();
        }
      } else {
        throw Exception('No user is currently logged in.');
      }
    } catch (e) {
      log('Error in editing user profile $e');
    }
  }
}
