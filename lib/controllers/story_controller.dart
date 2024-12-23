import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:orca_social_media/models/story_model.dart';
import 'package:uuid/uuid.dart';

class StoryProvider extends ChangeNotifier {
  //----------------------IMAGE---------------------->>

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;
  CroppedFile? _croppedImg;
  CroppedFile? get croppedImg => _croppedImg;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(bool pickImagesource) async {
    try {
      _selectedImage = await picker.pickImage(
          source: pickImagesource ? ImageSource.gallery : ImageSource.camera);

      if (_selectedImage != null) {
        await cropImage(_selectedImage!);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> cropImage(XFile image) async {
    try {
      _croppedImg = await ImageCropper().cropImage(
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
      print(e);
    }
  }

  Future<void> uploadAndAddStory({
    required BuildContext context,
    required String userId,
    required TextEditingController captionController,
  }) async {
    if (_croppedImg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image for story')));
      return;
    }
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploading story....')));

      final fileName = const Uuid().v4();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('stories/${fileName}_${DateTime.now().toIso8601String()}');

      final uploadTask = storageRef.putFile(File(_croppedImg!.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      final storyUrl = await snapshot.ref.getDownloadURL();

      final newStory = StoryModel
      (id: fileName,
       image: storyUrl,
       caption: captionController.text.trim(), 
       date: DateFormat('MMM,d,yyyy').format(DateTime.now())
       );

       await createStory(userId, newStory.toMap());
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Story uploaded successfully'))
       );
       await loadStories(userId);

       resetImage();
    } catch (e) {
      log('Error uploading story....$e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading story...$e')));
    }
  }

  void resetImage() {
    _selectedImage = null;
    _croppedImg = null;

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //----------------------CRUD---------------------->>

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  Future<void> createStory(String userId, Map<String, dynamic> stories) async {
    if (userId.isEmpty) {
      log('Error: userId is empty or null');
      return;
    }

    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.collection('stories').add(stories);
      log('Story added successfully');
    } catch (e) {
      log('Failed to add post:$e');
    }
  }

  Future<List<StoryModel>> fetchStories(
      String userid) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userid);
      final QuerySnapshot storySnapshot =
          await userDocRef.collection('stories').get();

      final stories = storySnapshot.docs.map((doc) {
        return StoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      log('Fetched ${stories.length} stories');
      return stories;
    } catch (e) {
      log('Failed to fetch stories:$e');
      return [];
    }
  }

  Future<void> loadStories(String userId)async{
    try{
      _stories = await fetchStories(userId);
      notifyListeners();
    }catch (e){
      log('Failed to load stories: $e');
    }
  }
}
