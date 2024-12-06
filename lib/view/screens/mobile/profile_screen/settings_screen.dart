
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/auth_provider.dart';
import 'package:orca_social_media/controllers/login_shared_prefs.dart';
import 'package:orca_social_media/view/screens/mobile/starting_page_screens/login_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderState>(context);
    final loginPrefs = Provider.of<LoginSharedPrefs>(context);
    final mediaQuery = MediaQueryHelper(context);
    final List<IconData> settingsIcons = [
      Icons.bookmark_added,
      Icons.archive,
      Icons.block,
      Icons.report,
      Icons.info_outline_rounded
    ];

    final List<String> settingsNames = [
      'Saved',
      'Archive',
      'Blocked',
      'Report a problem',
      'About'
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                child: TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      label: Text('Search'),
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: mediaQuery.screenHeight * 0.34,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(settingsIcons[index]),
                        title: Text(settingsNames[index]),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Divider(
                  thickness: 3,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {}, child: const Text("Add Account")),
                      TextButton(
                          onPressed: () async {
                             showDialog(context: context, builder: (context) {
                               return AlertDialog(
                                title:  Text("Confirm Logout"),
                                content: Text("Are you sure you want to log out?"),
                                actions: [
                                    TextButton(onPressed: (){
                                    Navigator.of(context).pop();  
                                    }, child: Text('Cancel')),
                                  TextButton(onPressed: () async{
                                    await authProvider.signOut();
                                    await loginPrefs.setLoginStatus(false);
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> router) => false);

                                  }, child: Text('Log out'))
                                  
                                  
                                ],
                               );
                             },);
                             
                            
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
}
