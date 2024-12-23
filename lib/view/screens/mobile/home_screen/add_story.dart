import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/story_controller.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:provider/provider.dart';

class StoryAddingPage extends StatefulWidget {
  final String? userId;

  StoryAddingPage({super.key, required this.userId});

  @override
  State<StoryAddingPage> createState() => _StoryAddingPageState();
}

class _StoryAddingPageState extends State<StoryAddingPage> {
  final TextEditingController _captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      appBar: CustomAppbar(
        leading: IconButton(
            onPressed: () {
              storyProvider.resetImage();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Add story'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<StoryProvider>(
            builder: (context, storyProvider, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await storyProvider.pickImage(false);
                      },
                      child: Container(
                        height: mediaQuery.screenHeight * 0.6,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: storyProvider.selectedImage != null
                            ? Image.file(
                                File(storyProvider.croppedImg!.path),
                                fit: BoxFit.cover,
                              )
                            : Center(child: Text("Tap to select an image")),
                      ),
                    ),
                    SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          String userid = widget.userId ?? '';
                          if (storyProvider.selectedImage == null &&
                              _captionController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please fill missing fields')));
                            return;
                          }
                          await storyProvider.uploadAndAddStory(
                              context: context,
                              userId: userid,
                              captionController: _captionController);
                        } catch (e) {
                          log('failed to add story....$e');
                        }
                      },
                      child: Text("Upload Story"),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
