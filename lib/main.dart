import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/auth_provider.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/fetch_datas_controller.dart';
import 'package:orca_social_media/controllers/forgot_password_controller.dart';
import 'package:orca_social_media/controllers/image_picker_provider.dart';
import 'package:orca_social_media/controllers/login_provider.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:orca_social_media/controllers/navigation_provider.dart';
import 'package:orca_social_media/controllers/search_controller.dart';
import 'package:orca_social_media/controllers/tab_bar_controller.dart';
import 'package:orca_social_media/controllers/textfield_provider.dart';
import 'package:orca_social_media/firebase_options.dart';
import 'package:orca_social_media/models/auth_repository.dart';
import 'package:orca_social_media/view/screens/mobile/splash_screen/splash_screen.dart';
import 'package:orca_social_media/view/screens/mobile_or_web/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
        create: (context) => LoginSharedPrefs(), child: MyApplication()),
  );
}

class MyApplication extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

  MyApplication({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProviderState(authRepository: AuthRepository())),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SearchControllerProvider()),
        ChangeNotifierProvider(create: (_) => TextfieldProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PageControllerProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPassController()),
        ChangeNotifierProvider(create: (_) => FetchUpcomingCourses())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.oRwhite,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: AppColors.oRBlack),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: AppColors.oRBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          primaryColor: AppColors.oRwhite,
        ),
        home: mediaQuery.isMobile ? const SplashScreen() : const SignUp(),
      ),
    );
  }
}