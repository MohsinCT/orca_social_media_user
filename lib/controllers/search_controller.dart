import 'package:flutter/material.dart';

class SearchControllerProvider extends ChangeNotifier {
  bool isSearchButtonClicked = false;
  

  void toggleSearchButtonState() {
    isSearchButtonClicked = !isSearchButtonClicked;
    notifyListeners(); 
  }

  
}
