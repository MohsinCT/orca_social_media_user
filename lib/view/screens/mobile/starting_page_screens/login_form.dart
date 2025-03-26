import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/bottom_nav_screen.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/constants/validation.dart';
import 'package:orca_social_media/controllers/auth/auth_provider.dart';
import 'package:orca_social_media/controllers/loading_provider.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/forgot_password_page.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_button.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_password_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.formkey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return ChangeNotifierProvider(
      create: (_) => LoadingProvider(),
      child: Consumer2<LoadingProvider, LoginSharedPrefs>(
        builder: (context, loadingProvider, loginSharedPrefs, child) {
          return Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: emailController, 
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>ValidationUtils.validateemail(value)
                  ),
                SizedBox(
                  height: mediaQuery.screenHeight * 0.02,
                ),
                CustomTextField(
                  controller: passwordController,
                   labelText: 'Password',
                   validator: (value) => ValidationUtils.validate(value, 'Password'),
                   isPassword: true,
                   ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Forgot'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                        },
                        child: const Text('Password ?',style: TextStyle(
                          color: Colors.black
                        ),))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQuery.screenHeight * 0.03,
                    bottom: mediaQuery.screenHeight * 0.01,
                  ),
                  child: CustomButton(
                    onTap: loadingProvider.isLoading
                        ? null
                        : () async {
                            if (formkey.currentState?.validate() == true) {
                              loadingProvider.setLoading(true);
                              try {
                                final authProvider =
                                    Provider.of<AuthProviderState>(context,
                                        listen: false);
                                await authProvider.signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);

                                if (authProvider.user != null) {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'userEmail', emailController.text);

                                  loginSharedPrefs.setLoginStatus(true);

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavScreen(),
                                  
                                    ),
                                  );
                                }
                                
                                passwordController.clear();
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('$e'),
                                  backgroundColor: Colors.red,
                                ));
                                // ignore: avoid_print
                                print(e);
                              } finally {
                                loadingProvider.setLoading(false);
                              }
                            }
                          },
                    buttontext: loadingProvider.isLoading
                        ? const CustomLoadingButton()
                        :Text('Login', style:TextStyle(color: Colors.white), // Set text when not loading

                    // Default Text if not loading
                  ),
                ),
                )
              ]
            ),
          );
        },
      ),
    );
  }
}
