import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/media_provider.dart';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PostScreen extends StatefulWidget {
  final String? userId;
  PostScreen({super.key, required this.userId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final postProvider = Provider.of<MediaProvider>(context, listen: false);

  

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Share Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media Preview
              Consumer<MediaProvider>(
                builder: (context, provider, child) {
                  if (provider.selectedVideo != null &&
                      provider.videoPlayerController != null) {
                    // Video Preview
                    return AspectRatio(
                      aspectRatio:
                          provider.videoPlayerController?.value.aspectRatio ??
                              16 / 9,
                      child: VideoPlayer(provider.videoPlayerController!),
                    );
                  } else if (provider.croppedImage != null) {
                    // Image Preview
                    return Container(
                      width: mediaQuery.screenWidth,
                      height: mediaQuery.screenHeight * 0.45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Image.file(
                        File(provider.croppedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    // Placeholder
                    return Container(
                      width: mediaQuery.screenWidth,
                      height: mediaQuery.screenHeight * 0.45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[500],
                          size: 50,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Choose an option'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Pick Image from Gallery'),
                                  onTap: () {
                                    postProvider.pickImage(true);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take Photo'),
                                  onTap: () {
                                    postProvider.pickImage(false);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.photo),
                    label: const Text('Pick Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Choose an option'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.video_library),
                                  title: const Text('Pick Video from Gallery'),
                                  onTap: () {
                                    postProvider.pickVideo(true);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.videocam),
                                  title: const Text('Record Video'),
                                  onTap: () {
                                    postProvider.pickVideo(false);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.video_library),
                    label: const Text('Pick Video'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Caption Input
              TextFormField(
                controller: _captionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Write a Caption...',
                  alignLabelWithHint: true,
                  hintText: 'Describe your post...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 12.0,
                  ),
                ),
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Caption cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Share Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try{

                      String  userId = widget.userId ?? '';
                    if (postProvider.selectedImage == null &&
                        postProvider.selectedVideo == null &&
                        _captionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill missing fields'),
                        ),
                      );
                      return;
                    }
                    await postProvider.uploadMediaAndCreatePost(
                      context: context, 
                      userId: userId, 
                      captionController: _captionController);

                    }catch (e){
                      log('failed to add a new post $e');

                    }
                    

                  
                  },
                  child: const Text('Share'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

