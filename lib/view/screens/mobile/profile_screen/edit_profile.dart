import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:provider/provider.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_password_field.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  const EditProfile({super.key, required this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nickNameController;
  late TextEditingController userNameController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    nickNameController = TextEditingController(text: widget.user.nickname);
    userNameController = TextEditingController(text: widget.user.username);
    bioController = TextEditingController(text: widget.user.bio);
    locationController = TextEditingController(text: widget.user.location);
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Provider.of<UserProvider>(context, listen: false)
          .setProfileImage(File(pickedImage.path));
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.editUserProfile(
        username: userNameController.text.trim(),
        bio: bioController.text.trim(),
        nickname: nickNameController.text.trim(),
        location: locationController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.screenWidth * 0.1,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: Provider.of<UserProvider>(context,
                                            listen: false)
                                        .profileImage !=
                                    null
                                ? FileImage(Provider.of<UserProvider>(context,
                                        listen: false)
                                    .profileImage!)
                                : NetworkImage(widget.user.profilPicture)
                                    as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Edit Image'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.screenWidth * 0.05,
                  ),
                  child: Card(
                    color: const Color.fromARGB(255, 201, 201, 201),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          NewCustomTextFormField(
                            controller: nickNameController,
                            labelText: 'Nickname',
                          ),
                          const SizedBox(height: 16),
                          NewCustomTextFormField(
                            controller: userNameController,
                            labelText: 'Username',
                          ),
                          const SizedBox(height: 16),
                          NewCustomTextFormField(
                            controller: bioController,
                            labelText: 'Bio',
                          ),
                          const SizedBox(height: 16),
                          NewCustomTextFormField(
                            controller: locationController,
                            labelText: 'Location',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.screenWidth * 0.05,
                  ),
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
