import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updateUsername(String value) {
    username = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  bool validate() {
    if (email.isEmpty) return false;
    if (username.isEmpty) return false;
    if (password.length < 6) return false;
    if (confirmPassword != password) return false;
    return true;
  }
}
