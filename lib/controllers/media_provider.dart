// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:orca_social_media/models/post_model.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:uuid/uuid.dart';

class MediaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final picker = ImagePicker();
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

  Future<void> uploadMediaAndCreatePost({
    required BuildContext context,
    required String userId,
    required TextEditingController captionController,
  }) async {
    if (_croppedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image to upload.")));
      return;
    }

    try {
      final fileName = const Uuid().v4();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts/${fileName}_${DateTime.now().toIso8601String()}');

      final uploadTask = storageRef.putFile(File(_croppedImage!.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      final mediaUrl = await snapshot.ref.getDownloadURL();

      final newPost = PostModel(
        id: fileName,
        userId: userId,
        image: mediaUrl,
        caption: captionController.text.trim(),
        date: DateFormat('MMM,d,yyyy').format(DateTime.now()),
        likedUsers: [],
      );

      await createPost(userId, newPost.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post created successfully.")));

      // Reset form
      resetMedia();
      captionController.clear();
    } catch (e) {
      log('Error uploading media: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error uploading media: $e")));
    }
  }

  void resetMedia() {
    _selectedImage = null;
    _croppedImage = null;
    notifyListeners();
  }

  Future<void> createPost(String userId, Map<String, dynamic> post) async {
    if (userId.isEmpty) {
      log('Error: userId is empty or null');
      return;
    }

    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.collection('posts').add(post);
      log('Post added successfully!');
    } catch (e) {
      log('Failed to add post: $e');
    }
  }

  Future<List<PostModel>> fetchPosts(String userId) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      final QuerySnapshot postSnapshot =
          await userDocRef.collection('posts').get();

      final posts = postSnapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      log('Fetched ${posts.length} posts');
      return posts;
    } catch (e) {
      log('Failed to fetch posts: $e');
      return [];
    }
  }

  Future<void> updatePostCaption(String postId, String newCaption) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final postRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('posts')
          .where('id', isEqualTo: postId)
          .limit(1)
          .get();
      if (postRef != null) {
        final postUid = postRef.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('posts')
            .doc(postUid)
            .update({'caption': newCaption});
      }
    }
  }

  Future<void> deletePost(String postId) async {
    log('this is the id  $postId');
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final postRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('posts')
          .where('id', isEqualTo: postId)
          .limit(1)
          .get();
      if (postRef != null) {
        final postUid = postRef.docs.first.id;
        log('this is $postUid');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('posts')
            .doc(postUid)
            .delete();
      }
    }
  }

  Future<Map<String, dynamic>?> fetchUserAndPosts() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          UserModel userModel =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

          QuerySnapshot querySnapshot = await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .collection('posts')
              .orderBy('date', descending: true)
              .get();

          List<PostModel> posts = querySnapshot.docs
              .map((doc) =>
                  PostModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          return {'user': userModel, 'posts': posts};
        }
      }
      return null;
    } catch (e) {
      log('Error fetching user details and posts : $e');
      return null;
    }
  }

  final List<PostModel> _posts = []; // Store posts

  List<PostModel> get posts => _posts;

  // Function to fetch posts (mock or from Firebase)
  void fetchlPosts(List<PostModel> fetchedPosts) {
    _posts.clear();
    _posts.addAll(fetchedPosts);
    notifyListeners();
  }

  List<Map<String, dynamic>> _followingsDataWithPosts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get followingDataWithPosts =>
      _followingsDataWithPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFollowingsWithLatestPost(
      String userId  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> followingsDataWithPosts = [];
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final List<dynamic> followingsIds = userDoc.data()?['followings'] ?? [];

      if (followingsIds.isNotEmpty) {
        for (String followingsId in followingsIds) {
          final followingsDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(followingsId)
              .get();

          if (followingsDoc.exists) {
            // Fetch the latest post for this following user
            QuerySnapshot postSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(followingsId)
                .collection('posts')
                .orderBy('date', descending: true)
                .limit(1)
                .get();

            Map<String, dynamic> followingData = followingsDoc.data()!;

            // Include the latest post if available
            if (postSnapshot.docs.isNotEmpty) {
              // followingData['latestPost'] = postSnapshot.docs.first.data();
              // followingData['latestPost']['id'] = postSnapshot.docs.first.id;

              followingData['latestPost'] = {
                'id':postSnapshot.docs.first.id,
                ...postSnapshot.docs.first.data() as Map<String , dynamic>
              };
            } else {
              followingData['latestPost'] = null;
            }

            followingsDataWithPosts.add(followingData);
          }
        }
      }

      _followingsDataWithPosts = followingsDataWithPosts;
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Error fetching posts: $e';
      debugPrint('Error fetching followings and latest posts: $e');
      _isLoading = false;
    }
    notifyListeners();
  }

  //now modified

  Map<String, bool> postLikeStatus = {};

  bool isPostLiked(String postId) {
    return postLikeStatus[postId] ?? false;
  }

  void toggleLike(String postId, String userId) async {
    bool currentStatus = postLikeStatus[postId] ?? false;
    postLikeStatus[postId] = !currentStatus;
    notifyListeners();

    DocumentReference postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts')
        .doc(postId);

    if (postLikeStatus[postId] == true) {
      await postRef.update({
        'likedUsers': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      await postRef.update({
        'likedUsers': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }

//

  @override
  void dispose() {
    _croppedImage = null;
    super.dispose();
  }
}
