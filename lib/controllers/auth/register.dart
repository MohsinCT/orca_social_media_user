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
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _userId;

  String? get userId => _userId;

  List<UserModel> _usersList = [];
  List<UserModel> get usersList => _usersList;

  String? getLoggedUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

 UserModel? _currentUserDetails;

 UserModel? get currentUserDetails => _currentUserDetails;

 Future<void> fetchCurrentUserDetails()async{
  try{
    User? currentUser = _auth.currentUser;
    if(currentUser != null){
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if(userDoc.exists){
        _currentUserDetails = UserModel.fromMap(userDoc.data() as Map<String , dynamic>);
        notifyListeners();
      } 
    }

  }catch (e){

  }
 }




  //--------------------------------FetchSingleUser------------------------------------//

  UserModel? userDetails;

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
    return null;
  }

  UserModel? _loggedUserDetails;
  UserModel? get loggedUserDetails => _loggedUserDetails;

  void fetchCurrentUser() async {
    _loggedUserDetails = await fetchUserDetails();
    if (_loggedUserDetails != null) {
      log('User fetched: ${_loggedUserDetails}');
    } else {
      log('no user founc');
    }
  }

  //--------------------------------FetchAllUsers------------------------------------//
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
  // Future<void> fetchAllUsers() async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore
  //         .collection('users')
  //         .orderBy('timestamp', descending: true)
  //         .get();

  //         _usersList = snapshot.docs.map((doc){
  //           try{
  //             return UserModel.fromDocument(doc);

  //           } catch (e){
  //             ret
  //           }
  //         }).where((users) => users != null).cast()<UserModel>().toList();
  //   } catch (e) {}
  // }

  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  List<UserModel> _filteredUsers = [];
  List<UserModel> get filteredUsers => _filteredUsers;

  Future<void> fetchAndSetUsers() async {
    _allUsers = await fetchAllUsers();
    _filteredUsers = _allUsers;
    notifyListeners();
  }

  void filterUsers(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredUsers = [];
    } else {
      _filteredUsers = _allUsers
          .where((user) => user.username.toLowerCase().contains(_searchQuery))
          .toList();
    }
    notifyListeners();
  }

  Future<void> loadUserData() async {
    try {
      _user = await fetchUserDetails();
      _allUsers = await fetchAllUsers();
      notifyListeners();
    } catch (e) {
      log('Failed to load user data');
    }
  }

  //--------------------------------FetchUserById------------------------------------//
  Future<UserModel> fetchUserById(String userId) async {
    // Example Firebase fetch logic
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (docSnapshot.exists) {
      return UserModel.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  }

  //--------------------------------Add User------------------------------------//

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
          id: userCredential.user!.uid,
          email: email,
          password: password,
          username: username,
          profilPicture: downloadImage.toString(),
          nickname: 'Add nickname',
          bio: 'Add Bio',
          location: 'Add location',
          date: DateFormat('MMM,d,yyyy').format(DateTime.now()),
          postCount: 0,
          timestamp: DateTime.now(),
          followersCount: 0,
          followingCount: 0,
          followers: [],
          followings: [],
          likedUser: [],
          likesCount: 0,
          isDisabled: false,
          isOnline: false);

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
      String fileName = basename(image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
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
            log('Image uploaded successfully: $updatedImageUrl');
            updatedData['profilePicture'] = updatedImageUrl;
          } else {
            log('Image upload failed.');
          }
        }

        // Update other user details if provided
        if (username != null) updatedData['username'] = username;
        if (bio != null) updatedData['bio'] = bio;
        if (nickname != null) updatedData['nickname'] = nickname;
        if (location != null) updatedData['location'] = location;

        if (updatedData.isNotEmpty) {
          log('Updated data: $updatedData');

          // Update the Firestore document for the current user
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .update(updatedData);

          // Fetch the updated user details and notify listeners
          _user = await fetchUserDetails();
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

  //--------------------------------POST SECTION------------------------------------//

  Future<List<PostModel>> fetchPosts() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('posts')
            .orderBy('date', descending: true)
            .get();

        return querySnapshot.docs
            .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error fetching posts: $e');
      return [];
    }
  }

  Future<List<PostModel>> fetchPostsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching posts for user $userId: $e');
      return [];
    }
  }

  Future<void> increamentPostCount(String userId) async {
    try {
      if (_user != null) {
        _user!.postCount++;
        notifyListeners();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'postCount': _user!.postCount});
      }
    } catch (e) {
      log('not incresed$e');
    }
  }
  //--------------------------------Media Handling------------------------------------//

  File? _profileImage;
  File? get profileImage => _profileImage;
  final picker = ImagePicker();
  XFile? _selectedMedia;
  CroppedFile? _croppedMedia;
  XFile? _selectedVideo;
  File? get selectedMedia =>
      _selectedMedia != null ? File(_selectedMedia!.path) : null;
  File? get croppedMedia =>
      _croppedMedia != null ? File(_croppedMedia!.path) : null;
  XFile? get selectedVideo => _selectedVideo;

  File? _croppedImage;
  File? get croppedImage => _croppedImage;

  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  // Set image when it's picked
  void setCroppedImage(File image) {
    _croppedImage = image;
    notifyListeners();
  }

  // Set video controller when video is selected or recorded
  void setVideoController(VideoPlayerController controller) {
    _videoPlayerController = controller;
    notifyListeners();
  }

  // Reset video and image
  void resetMedia() {
    _croppedImage = null;
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    notifyListeners();
  }

  Future<void> pickMedia(
      {required bool isGallery, required bool isVideo}) async {
    if (isVideo) {
      _selectedVideo = await picker.pickVideo(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
      );
      _selectedMedia = null;
      _croppedMedia = null;
    } else {
      _selectedMedia = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
      );
      _croppedMedia = null;

      if (_selectedMedia != null) {
        await cropImage(_selectedMedia!);
      }
      _selectedVideo = null;
    }
    notifyListeners();
  }

  Future<void> cropImage(XFile image) async {
    _croppedMedia = await ImageCropper().cropImage(
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
          ],
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    notifyListeners();
  }

  Future<String?> uploadMedia(File media, String folder) async {
    try {
      String fileName = basename(media.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$folder/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(media);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      log('Error uploading media: $e');
      return null;
    }
  }

  //--------------------------------Add Post------------------------------------//

  Future<void> addPost({
    required String caption,
    required File? image,
    required File? video,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String? imageUrl =
            image != null ? await uploadMedia(image, 'image') : null;
        String postId = _firestore.collection('posts').doc().id;
        PostModel newPost = PostModel(
          id: postId,
          userId: currentUser.uid,
          image: imageUrl ?? '',
      
          caption: caption,
          date: DateFormat('MMM,d,yyyy').format(DateTime.now()),
          likedUsers: [],
        
        );

        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('posts')
            .doc(postId)
            .set(newPost.toMap());

        log('Post added successfully');
        notifyListeners();
      }
    } catch (e) {
      log('Error adding post: $e');
    }
  }

  //--------------------------------FetchLatestPosts------------------------------------//
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  Future<void> fetchLatestPosts(String userId) async {
    final userPosts = await fetchPostsByUserId(userId);

    userPosts.sort((a, b) => b.date.compareTo(a.date));
    if (userPosts.isNotEmpty) {
      _posts.insert(0, userPosts.first);
      notifyListeners();
    }
  }

  //--------------------------------Dispose Media Controllers------------------------------------//
  void disposeMedia() {
    _selectedMedia = null;
    _croppedMedia = null;
    _selectedVideo = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }

  Future<void> updateComplaint(
      BuildContext context, String userId, String newComplaint) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'complaint': newComplaint});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint send successfullyy')));
    } catch (e) {
      log('Error sending complaint $e');
    }
  }
}
