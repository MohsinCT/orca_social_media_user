import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:orca_social_media/models/dummy_post_model.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:uuid/uuid.dart';

class DummyPostController extends ChangeNotifier {
  final imagePicker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final String _collection = 'dummyposts';
  List<DummyPostModel> _posts = [];
  List<DummyPostModel> get posts => _posts;

  XFile? _selectedImage;
  CroppedFile? _croppedImage;

  XFile? get selectedImage => _selectedImage;
  CroppedFile? get croppedImage => _croppedImage;

  Future<void> pickImage(bool pickImage) async {
    try {
      _selectedImage = await picker.pickImage(
        source: pickImage ? ImageSource.gallery : ImageSource.camera,
      );

      if (_selectedImage != null) {
        await cropImage(_selectedImage!);
      }

      notifyListeners();
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> cropImage(XFile image) async {
    try {
      _croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );
      notifyListeners();
    } catch (e) {
      log('Error cropping image: $e');
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      String fileName = const Uuid().v4();
      Reference ref = _storage.ref().child("post_images/$fileName.jpg");
      await ref.putFile(File(_croppedImage!.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<List<DummyPostModel>> fetchPosts(String userid) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userid)
          .collection(_collection)
          .get();

      _posts = snapshot.docs
          .map((doc) => DummyPostModel.fromMap(doc.data()))
          .toList();

          return _posts;
    
    } catch (e) {
      print('Error fetching posts $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> fetchUserAndPosts() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          UserModel userModel =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
          QuerySnapshot querySnapshot = await firestore
              .collection('users')
              .doc(currentUser.uid)
              .collection(_collection)
              .orderBy('date', descending: true)
              .get();

          List<DummyPostModel> posts = querySnapshot.docs
              .map((doc) =>
                  DummyPostModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

              return {
                'user':userModel,
                'dummyPosts':posts
              };
        }
      }
      return null;
    } catch (e) {
      log('Error fetching user details and posts : $e');
      return null;
    }
  }

  Future<void> addPost(String userId, String caption, File imageFile) async {
    try {
      String? imageUrl = await uploadImage(imageFile);
      if (imageUrl == null) return;
      String postId = const Uuid().v4();
      DummyPostModel newPost = DummyPostModel(
          id: postId,
          userId: userId,
          image: imageUrl,
          caption: caption,
          date: DateFormat('MMM,d,yyyy').format(DateTime.now()));

      await firestore
          .collection('users')
          .doc(userId)
          .collection(_collection)
          .doc(postId)
          .set(newPost.toMap());

      _posts.add(newPost);
      notifyListeners();
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<void> deletePost(String userId, DummyPostModel post) async {
    try {
      Reference ref = _storage.refFromURL(post.image);
      await ref.delete();

      await firestore
          .collection("users")
          .doc(userId)
          .collection("posts")
          .doc(post.id)
          .delete();

      _posts.removeWhere((p) => p.id == post.id);
      notifyListeners();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }
}
