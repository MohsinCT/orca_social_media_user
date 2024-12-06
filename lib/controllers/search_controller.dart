import 'package:flutter/material.dart';

class SearchControllerProvider with ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  void setSearchText(String text) {
    searchController.text = text;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
