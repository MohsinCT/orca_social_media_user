import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/consts.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/auth_provider.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/complaints_controller.dart';
import 'package:orca_social_media/controllers/counter.dart';
import 'package:orca_social_media/controllers/dummy_post_controller.dart';
import 'package:orca_social_media/controllers/fetch_datas_controller.dart';
import 'package:orca_social_media/controllers/follow_button_controller.dart';
import 'package:orca_social_media/controllers/followings_controller.dart';
import 'package:orca_social_media/controllers/forgot_password_controller.dart';
import 'package:orca_social_media/controllers/image_picker_provider.dart';
import 'package:orca_social_media/controllers/like_animation_controller.dart';
import 'package:orca_social_media/controllers/like_controller.dart';
import 'package:orca_social_media/controllers/login_provider.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:orca_social_media/controllers/media_provider.dart';
import 'package:orca_social_media/controllers/navigation_provider.dart';
import 'package:orca_social_media/controllers/notification_controller.dart';
import 'package:orca_social_media/controllers/save_post_controller.dart';
import 'package:orca_social_media/controllers/search_controller.dart';
import 'package:orca_social_media/controllers/story_controller.dart';
import 'package:orca_social_media/controllers/story_state_controller.dart';
import 'package:orca_social_media/controllers/tab_bar_controller.dart';
import 'package:orca_social_media/controllers/textfield_provider.dart';
import 'package:orca_social_media/firebase_options.dart';
import 'package:orca_social_media/models/auth_repository.dart';
import 'package:orca_social_media/view/screens/mobile/splash_screen/splash_screen.dart';
import 'package:orca_social_media/view/screens/mobile_or_web/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);
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
        ChangeNotifierProvider(create: (_) => FetchUpcomingCourses()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => MediaProvider()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => FollowingsProvider()),
        ChangeNotifierProvider(create: (_) => SearchControllerProvider()),
        ChangeNotifierProvider(create: (_) => LikeAnimationProvider()),
        ChangeNotifierProvider(create: (_) => LikeProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintController()),
        ChangeNotifierProvider(create: (_) => SavePostProvider()),
        ChangeNotifierProvider(create: (_) => DummyPostController()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ProxyProvider<TickerProvider, StoryStateController>(
            update: (_, vsync, __) => StoryStateController(vsync, context))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.oRwhite,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.oRwhite,
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
