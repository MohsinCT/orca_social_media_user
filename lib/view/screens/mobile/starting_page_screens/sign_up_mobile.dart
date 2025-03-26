import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/image_picker_provider.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/login_screen.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/user_form.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_divider.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_text_login.dart';
import 'package:orca_social_media/view/widgets/mobile/google_signup_button.dart';
import 'package:provider/provider.dart';

class SignUpMobile extends StatefulWidget {
  const SignUpMobile({super.key});

  @override
  State<SignUpMobile> createState() => _SignUpMobileState();
}

class _SignUpMobileState extends State<SignUpMobile> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController conformpassController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final imagePickerProvider = Provider.of<ImagePickerProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
         backgroundColor: Colors.grey[300],
        appBar: CustomAppbar(
         
          title: Image.asset(
            AppImages.orcaLogoTrans,
            height: 60,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: mediaQuery.screenHeight * 0.0,
                  left: mediaQuery.screenWidth * 0.03,
                  right: mediaQuery.screenWidth * 0.03),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: mediaQuery.screenWidth * 0.07,
                      top: mediaQuery.screenHeight * 0.03,
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign up',
                        style:
                            TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: imagePickerProvider.selectedImage != null
                            ? FileImage(imagePickerProvider.selectedImage!)
                            : const AssetImage('assets/default_person.avif')
                                as ImageProvider,
                      ),
                      TextButton(
                          onPressed: () {
                            _showImagePickerDialog(context, imagePickerProvider);
                          },
                          child: const Text(
                            'Add image',
                            style: TextStyle(color: Colors.black),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.screenHeight * 0.02,
                          horizontal: mediaQuery.screenWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            UserFormPage(
                                usernameController: usernameController,
                                emailController: emailController,
                                passwordController: passwordController,
                                formkey: _formkey,
                                confirmController: conformpassController),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQuery.screenHeight * 0.03,
                                    bottom: mediaQuery.screenHeight * 0.01),
                                child: SignUpButton(
                                    formKey: _formkey,
                                    usernameController: usernameController,
                                    emailController: emailController,
                                    image: imagePickerProvider.selectedImage,
                                    passwordController: passwordController)),
                            const CustomDivider(),
                            Padding(
                              padding: EdgeInsets.only(
                                top: mediaQuery.screenHeight * 0.01,
                              ),
                              child: GoogleSignUp(
                                  onTap: () {}, text: 'Sign up with Google'),
                            ),
                            CustonTextLogin(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => LoginScreen()));
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the image picker dialog
  void _showImagePickerDialog(
      BuildContext context, ImagePickerProvider imagePickerProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Pick from Gallery'),
              onTap: () {
                imagePickerProvider.pickImage();
                Navigator.pop(context); // Close the dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Picture'),
              onTap: () {
                imagePickerProvider.takePicture();
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
