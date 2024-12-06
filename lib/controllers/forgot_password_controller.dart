import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassController extends ChangeNotifier {
  Future<void> passwordReset(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content:
                  Text('Password reset email sent. Please check your inbox'),
              duration: Duration(seconds: 4),
            ),
          )
          .closed
          .then((reson) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      log('error$e');
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }
}
