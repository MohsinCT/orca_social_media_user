import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/auth_provider.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/report_screen.dart';
import 'package:orca_social_media/view/screens/mobile/profile_screen/saved_post_screen.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/login_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderState>(context);
    final loginPrefs = Provider.of<LoginSharedPrefs>(context);
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? currentUser = userProvider.getLoggedUserId();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: mediaQuery.screenHeight * 0.2,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => SavedPostsScreen(userId: currentUser!)));
                        },
                        child: _customListTile(Icons.bookmark_added, 'Saved',
                            Icons.arrow_forward_ios),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReportPage()));
                          },
                          child: _customListTile(Icons.report,
                              'Report a problem', Icons.arrow_forward_ios)),
                      _customListTile(Icons.info_outline_rounded, 'About',
                          Icons.arrow_forward_ios),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Confirm Logout"),
                                  content:
                                      Text("Are you sure you want to log out?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () async {
                                          await authProvider.signOut();
                                          await loginPrefs
                                              .setLoginStatus(false);
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()),
                                                  (Route<dynamic> router) =>
                                                      false);
                                        },
                                        child: Text('Log out'))
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Log out",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _customListTile(
      IconData leadingicon, String text, IconData trailingIcon) {
    return ListTile(
      leading: Icon(leadingicon),
      title: Text(text),
      trailing: Icon(trailingIcon),
    );
  }
}
