import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // To handle file

class ImagePickerProvider with ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path); // Store the picked image
      notifyListeners(); // Notify listeners that the image has changed
    }
  }

  // Function to take a picture using the camera
  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path); // Store the taken picture
      notifyListeners(); // Notify listeners that the image has changed
    }
  }

  // Function to clear the selected image
  void clearImage() {
    _selectedImage = null; // Clear the image
    notifyListeners(); // Notify listeners that the image has changed
  }
}
