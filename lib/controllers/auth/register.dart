import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/models/register_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class UserProvider with ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<UserModel?> fetchUserDetails()async{
    try{
      User? currentUser = _auth.currentUser;
      if(currentUser != null){
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if(userDoc.exists){
          return UserModel.fromMap(userDoc.data() as Map<String , dynamic>);
        }
      }
      return null;
    } catch (e){
      log('Error fetching user credentials $e');
    }
  }

Future<void> registerUser({
  required String username,
  required String email,
  required String password,
  required File profilPicture
}) async{
  try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    String? dounloadImAGE=await uploadImage(profilPicture);

    UserModel user = UserModel(email: email, password: password, username: username ,profilPicture: dounloadImAGE.toString());

    await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toMap());
    notifyListeners();
  } catch (e){
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

}