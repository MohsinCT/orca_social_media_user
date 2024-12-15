import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:provider/provider.dart';

class UsersSearchList extends StatelessWidget {
  const UsersSearchList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider()..fetchAndSetUsers(),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final filteredUsers = userProvider.filteredUsers;

          return Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    userProvider
                        .filterUsers(query); // Filter users based on query
                  },
                ),
              ),

              // Display Logic Based on Search State
              if (userProvider.searchQuery.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Search users....',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else if (filteredUsers.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'User not found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserProfile(
                                      userId: user.id,
                                    ))),
                        child: ListTile(
                          leading: CircleAvatar(
                            // ignore: unnecessary_null_comparison
                            backgroundImage: user.profilPicture != null
                                ? NetworkImage(user.profilPicture)
                                : null,
                            // ignore: unnecessary_null_comparison
                            child: user.profilPicture == null
                                ? Icon(Icons.person)
                                : null,
                          ),
                          title: Text(user.username),
                          subtitle: Text(
                            user.nickname == 'Add nickname'
                                ? ''
                                : user.nickname,
                          ),
                          trailing: FollowButton(userId: user.id,),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
