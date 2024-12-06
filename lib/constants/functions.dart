import 'package:flutter/material.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/login_screen.dart';



class CustomRoute{
  Route createCustomRoute(){
  return PageRouteBuilder(
    pageBuilder: (context , animation , secondaryAnimation) =>  LoginScreen(),
     transitionsBuilder: (context, animation, secondaryAnimation, child) {
       const begin = Offset(0.0, 1.0);
       const end = Offset.zero;
       const curve = Curves.ease;

       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
       var fadeTween = Tween<double>(begin: 0.0,end: 1.0);

       return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
          ),
         );
     },
     );
}

}
