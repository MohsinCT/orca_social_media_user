import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';

class SearchControllerProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query, UserProvider userProvider) {
    _searchQuery = query;
    userProvider.filterUsers(query);
    notifyListeners();
  }
}
