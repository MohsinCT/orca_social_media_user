import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:orca_social_media/models/post_model.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class MediaProvider extends ChangeNotifier {
  final picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  XFile? _selectedImage;
  CroppedFile? _croppedImage;
  XFile? _selectedVideo;
  VideoPlayerController? _videoPlayerController;

  XFile? get selectedImage => _selectedImage;
  CroppedFile? get croppedImage => _croppedImage;
  XFile? get selectedVideo => _selectedVideo;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> pickImage(bool pickImage) async {
    try {
      _selectedImage = await picker.pickImage(
        source: pickImage ? ImageSource.gallery : ImageSource.camera,
      );

      if (_selectedImage != null) {
        await cropImage(_selectedImage!);
      }

      // Clear video-related data
      _selectedVideo = null;
      _videoPlayerController?.dispose();
      _videoPlayerController = null;

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

  Future<void> pickVideo(bool pickGalleryVideo) async {
    try {
      _selectedVideo = await picker.pickVideo(
        source: pickGalleryVideo ? ImageSource.gallery : ImageSource.camera,
      );

      // Clear image-related data
      _selectedImage = null;
      _croppedImage = null;

      if (_selectedVideo != null) {
        _videoPlayerController = VideoPlayerController.file(File(_selectedVideo!.path))
          ..initialize().then((_) {
            notifyListeners();
          });
      } else {
        _videoPlayerController?.dispose();
        _videoPlayerController = null;
      }

      notifyListeners();
    } catch (e) {
      log('Error picking video: $e');
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Uploading media...")));

      final fileName = const Uuid().v4();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts/${fileName}_${DateTime.now().toIso8601String()}');

      final uploadTask = storageRef.putFile(File(_croppedImage!.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      final mediaUrl = await snapshot.ref.getDownloadURL();

      final newPost = PostModel(
        id: fileName,
        image: mediaUrl,
        video: '',
        caption: captionController.text.trim(),
        date: DateFormat('MMM,d,yyyy').format(DateTime.now()),
      );

      await createPost(userId, newPost.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post created successfully.")));

      // Reset form
      resetMedia();
      captionController.clear();
    } catch (e) {
      log('Error uploading media: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading media: $e")));
    }
  }

  void resetMedia() {
    _selectedImage = null;
    _croppedImage = null;
    _selectedVideo = null;
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
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
      final QuerySnapshot postSnapshot = await userDocRef.collection('posts').get();

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

  Future<void> updatePost(String userId, String postId, Map<String, dynamic> updatedData) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.collection('posts').doc(postId).update(updatedData);
      log('Post updated successfully!');
    } catch (e) {
      log('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String userId, String postId) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.collection('posts').doc(postId).delete();
      log('Post deleted successfully!');
    } catch (e) {
      log('Failed to delete post: $e');
    }
  }

  @override
  void dispose() {
    _croppedImage = null;
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
