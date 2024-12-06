import 'package:flutter/material.dart';

class TextfieldProvider extends ChangeNotifier{
  bool _obscureText =  true;

  bool get obscureText => _obscureText;

  void toggleObscureText(){
    _obscureText =! _obscureText;
    notifyListeners();
  }

}