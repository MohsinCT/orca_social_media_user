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

//--------------------------------FetchSingleUser ------------------------------------//

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

  
 

  //--------------------------------FetchAllUsers ------------------------------------//
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('timestamp', descending: true) // Order by timestamp
          .get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching all users: $e');
      return [];
    }
  }
 List<UserModel> _filteredUsers = [];
  List<UserModel> get filteredUsers => _filteredUsers.isEmpty ? _allUsers : _filteredUsers;
  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  Future<void> fetchAndSetUsers() async {
    _allUsers = await fetchAllUsers();
    _filteredUsers = _allUsers;
    notifyListeners();
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      _filteredUsers = _allUsers
          .where((user) => user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  //--------------------------------Add User ------------------------------------//

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required File profilPicture,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? downloadImage = await uploadImage(profilPicture);

      UserModel newUser = UserModel(
        email: email,
        password: password,
        username: username,
        profilPicture: downloadImage.toString(),
        nickname: 'Add nickname',
        bio: 'Add Bio',
        location: 'Add location',
        date: DateFormat('MMM,d,yyyy').format(DateTime.now()),
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      // Add the new user to the top of _allUsers
      _allUsers.insert(0, newUser);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to register user: $e');
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

  void resetImage(String image) {
    image = '';
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

  //--------------------------------Search User------------------------------------//
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      // Ensure the query string is not empty
      if (query.trim().isEmpty) {
        return [];
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error searching users: $e');
      return [];
    }
  }

  List<UserModel> _searchResults = [];
List<UserModel> get searchResults => _searchResults;

Future<void> fetchSearchResults(String query) async {
  _searchResults = await searchUsers(query);
  notifyListeners();
}

}
