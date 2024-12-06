import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Method to toggle loading
  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
