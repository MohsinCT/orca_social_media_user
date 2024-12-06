import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/sign_up_mobile.dart';
import 'package:orca_social_media/view/screens/web/sign_up_web.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return mediaQuery.isMobile ? const SignUpMobile() : const SignUpWeb();
  }
}
