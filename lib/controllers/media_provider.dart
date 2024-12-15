import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class MediaProvider extends ChangeNotifier {
  final picker = ImagePicker();
  XFile? _selectedImage;
  CroppedFile? _croppedImage;
  XFile? _selectedVideo;
  VideoPlayerController? _videoPlayerController;

  XFile? get selectedImage => _selectedImage;
  CroppedFile? get croppedImage => _croppedImage;
  XFile? get selectedVideo => _selectedVideo;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Future<void> pickImage(bool pickGalleryImage) async {
    _selectedImage = await picker.pickImage(
      source: pickGalleryImage ? ImageSource.gallery : ImageSource.camera,
     );

    if (_selectedImage != null) {
      await cropImage(_selectedImage!);
    }
    _selectedVideo = null; // Clear any previously selected video
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    notifyListeners();
  }

  Future<void> cropImage(XFile image) async {
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
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    notifyListeners();
  }

  Future<void> pickVideo(bool pickGalleryVideo) async {
    _selectedVideo = await picker.pickVideo(
      source: pickGalleryVideo ? ImageSource.gallery : ImageSource.camera,
    );
    _selectedImage = null; // Clear any previously selected image
    _croppedImage = null; // Clear any cropped image

    if (_selectedVideo != null) {
      // Initialize the video player when a new video is picked
      _videoPlayerController = VideoPlayerController.file(File(_selectedVideo!.path))
        ..initialize().then((_) {
          notifyListeners();  // Notify listeners when the video is initialized
        });
    } else {
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
    }
    notifyListeners();
  }

  // Dispose video player controller when not needed
  @override
  void dispose() {
    _croppedImage = null;
    _videoPlayerController?.dispose();
    super.dispose();
  }
}

