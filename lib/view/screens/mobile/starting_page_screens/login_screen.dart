import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orca_social_media/constants/bottom_nav_screen.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/login_provider.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/login_form.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_divider.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/google_signup_button.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/sign_up_mobile.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_text_signup.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();

  bool isGooglePressed = true;

  @override
  Widget build(BuildContext context) {
    final loginPrefs = Provider.of<LoginSharedPrefs>(context);
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        title: Image.asset(
          AppImages.orcaLogoTrans,
          height: 60,
        ),
        centerTitle: true,
      ),
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: mediaQuery.screenHeight * 0.05,
                horizontal: mediaQuery.screenWidth * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: mediaQuery.screenHeight * 0.04,
                  ),
                  Icon(
                    Icons.lock,
                    size: mediaQuery.screenWidth * 0.15,
                  ),
                  SizedBox(
                    height: mediaQuery.screenHeight * 0.02,
                  ),
                  Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10, 
                  ),
                  SizedBox(
                    height: mediaQuery.screenHeight * 0.04,
                  ),
                  LoginForm(
                      formkey: _formKey,
                      emailController: loginProvider.emailController,
                      passwordController: loginProvider.passwordController),
                  const CustomDivider(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQuery.screenHeight * 0.01,
                    ),
                    child: GoogleSignUp(
                      onTap: () {
                        _signInWithGoogle(context);
                        loginPrefs.setLoginStatus(true);
                      },
                      text: 'Sign up with Google',
                    ),
                  ),
                  CustomTextSignup(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => const SignUpMobile(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _signInWithGoogle(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavScreen()));
    }
  } catch (e) {
    log('$e');
  }
}

// void _login(String email, String password, BuildContext context) async {
//   AuthProviderState _authState =
//       Provider.of<AuthProviderState>(context, listen: false);

//   try {
//     if (await _authState.signInUserAccount(email, password)) {
//       // If login is successful, navigate to the HomeScreen
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => BottomNavScreen()),
//       );
//     } else {
//       // Handle if signInUserAccount returns false, indicating failure
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid email or password")),
//       );
//     }
//   } catch (e) {
//     // Handle any other error by showing a SnackBar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("An error occurred: $e")),
//     );
//   }
// }
