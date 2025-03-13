import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';

import 'package:orca_social_media/controllers/search_controller.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/just_landed_users.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/random_users.dart';

import 'package:orca_social_media/view/screens/mobile/network_screen/users_list.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';

import 'package:provider/provider.dart';

class NetworkScreen extends StatelessWidget {
  NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchControllerProvider>(context);
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: Text('Networking'),
        actions: [
          searchProvider.isSearchButtonClicked
              ? IconButton(
                  onPressed: () {
                    searchProvider.toggleSearchButtonState();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ))
              : IconButton(
                  onPressed: () {
                    searchProvider.toggleSearchButtonState();
                  },
                  icon: Icon(Icons.search))
        ],
      ),
      body: searchProvider.isSearchButtonClicked
          ? UsersSearchList()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: mediaQuery.screenHeight * 0.01,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        left: mediaQuery.screenWidth * 0.04,
                        top: mediaQuery.screenHeight * 0.04),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('People just landed:'),
                    ),
                  ),
                  SizedBox(
                    height: mediaQuery.screenHeight * 0.15,
                    child: JustLandedUsers(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.screenHeight * 0.02,
                        horizontal: mediaQuery.screenWidth * 0.04),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Random people:'),
                    ),
                  ),

                  // Random people section - GridView with 2 items per row
                  RandomUsers()
                ],
              ),
            ),
    );
  }
}
