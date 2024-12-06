import 'package:flutter/material.dart';

class PageControllerProvider with ChangeNotifier {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  int get currentPage => _currentPage;
  PageController get pageController => _pageController;

  void setPage(int pageIndex) {
    _currentPage = pageIndex;
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void onPageChanged(int pageIndex) {
    _currentPage = pageIndex;
    notifyListeners();
  }
}
