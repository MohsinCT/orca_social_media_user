import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/navigation_provider.dart';
import 'package:orca_social_media/view/screens/mobile/academy_screen/academy.dart';
import 'package:orca_social_media/view/screens/mobile/chat_bot_screen/chat_bot.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/home_screen.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/network.dart';
import 'package:orca_social_media/view/screens/mobile/post_screen/post_screen.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavScreen extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    NetworkScreen(),
    ChatBotScreen(),
    AcademyScreen(),
    ProfileScreen()
  ];

  BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context , listen: false);
    final userId = userProvider.userId;
    return Scaffold(
      extendBody:
          true, // Enables the body to extend behind the bottom navigation bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(
                        //         builder: (context) => PostScreen(userId: userId,)))
                        //     .then(Navigator.of(context).pop);
                      },
                      child: Text(
                        'Share Post',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Divider(), // Divider between buttons
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        // Add message logic here
                      },
                      child: Text(
                        'Share Message',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),

      body: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return _screens[provider.currentIndex];
        },
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return CurvedNavigationBar(
            index: provider.currentIndex,
            height: 75, // Increased height for text space
            items: <Widget>[
              _buildNavItem(Icons.feed, "Home", provider.currentIndex == 0),
              _buildNavItem(
                  Icons.people, "Network", provider.currentIndex == 1),
              _buildNavItem(Icons.chat_bubble_rounded, "Chat bot",
                  provider.currentIndex == 2),
              _buildNavItem(
                  Icons.class_, "Academy", provider.currentIndex == 3),
              _buildNavItem(
                  Icons.person, "Profile", provider.currentIndex == 4),
            ],
            color: Colors.black, // Make the curved portion fully transparent
            buttonBackgroundColor:
                Colors.transparent, // Transparent button background
            backgroundColor: Colors
                .transparent, // Background behind the navigation is transparent
            animationCurve: Curves.easeInOutCubic,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              provider.setCurrentIndex(index);
            },
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
          color: isSelected ? Colors.orange : AppColors.oRwhite,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.orange : AppColors.oRwhite,
            fontSize: 11, // Adjust the font size as needed
          ),
        ),
      ],
    );
  }

}
