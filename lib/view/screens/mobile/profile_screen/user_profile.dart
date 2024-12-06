import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/settings_screen.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_user_details.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<String> tabNames = [
    'Posts',
    'Liked',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return DefaultTabController(
      length: tabNames.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
                },
                icon: const Icon(Icons.menu))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const UserDetails(),

                          TabBar(
                            tabs: tabNames
                                .map((tab) => Tab(
                                    text: tab)) // Create a tab for each name
                                .toList(),
                          ),

                          // TabBarView implementation
                          SizedBox(
                            height: mediaQuery.screenHeight * 0.5,
                            child: TabBarView(
                              children: [
                                // First Tab (Posts) with GridView
                                GridView.builder(
                                  padding: const EdgeInsets.all(10),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // Number of items in a row
                                    mainAxisSpacing:
                                        10.0, // Vertical space between grid items
                                    crossAxisSpacing:
                                        4.0, // Horizontal space between grid items
                                    childAspectRatio:
                                        1.0, // Aspect ratio of each item
                                  ),
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                                  shrinkWrap:
                                      true, // Make GridView take only the necessary height
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.asset(
                                        'assets/Credit card.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                  itemCount:
                                      9, // Set the total number of items here
                                ),

                                // Second Tab (Liked) - Example Content
                                const Center(
                                  child: Text('No Liked Posts'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
