
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/bottom_nav_screen.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/loading_provider.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final Widget buttonText; // Accept any widget, including Text or CircularProgressIndicator
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.buttonText, // Use a widget instead of just text
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Flexible(
      child: SizedBox(
        width:mediaQuery.screenWidth * 0.8 ,
        height: mediaQuery.screenHeight * 0.06,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
            elevation: 2,
          ),
          child: buttonText, // Render the passed widget (can be Text or anything else)
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  // ignore: prefer_typing_uninitialized_variables
  final image;

  SignUpButton({super.key, 
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController, 
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoadingProvider(),
      child: Consumer2<LoginSharedPrefs, LoadingProvider>(
        builder: (context, loginSharedPrefs, loadingProvider, child) =>
            ElevatedButton(
          onPressed: loadingProvider.isLoading
              ? null
              : () async {
                  if (formKey.currentState!.validate()) {
                    loadingProvider.setLoading(true); // Set loading to true
                    try {
                      await Provider.of<UserProvider>(context, listen: false)
                          .registerUser(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        profilPicture: image,
                      );

                      loginSharedPrefs.setLoginStatus(true);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('User registered successfully')),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (ctx) =>  BottomNavScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    } finally {
                      loadingProvider.setLoading(false); // Set loading to false
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: loadingProvider.isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text('Sign Up'),
        ),
      ),
    );
  }
}

