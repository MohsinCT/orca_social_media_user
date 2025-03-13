import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:provider/provider.dart';

class NetFollowings extends StatelessWidget {
  final String userId;
  const NetFollowings({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> fetchFollowings(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final List<dynamic> followingsIds = userDoc.data()?['followings'] ?? [];

    List<Map<String, dynamic>> followingsData = [];

    for (String followingsId in followingsIds) {
      final followingsDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(followingsId)
          .get();
      if (followingsDoc.exists) {
        followingsData.add(followingsDoc.data()!);
      }
    }
    return followingsData;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final String? currentUser = userProvider.getLoggedUserId();
    return Scaffold(
      appBar: CustomAppbar(
          automaticallyImplyleading: true, title: Text('Following')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.screenHeight * 0.02,
              horizontal: mediaQuery.screenWidth * 0.02,
            ),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchFollowings(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No following found.'));
                }

                final followings = snapshot.data!;
                final currentUserIndex = followings
                    .indexWhere((following) => following['id'] == currentUser);
                if (currentUserIndex != -1) {
                  final currentUserData = followings.removeAt(currentUserIndex);
                  followings.insert(0, currentUserData);
                }

                return ListView.builder(
                  itemCount: followings.length,
                  itemBuilder: (context, index) {
                    final following = followings[index];
                    return following['id'] == currentUser
                        ? ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  following['profilePicture'] ?? ''),
                              child: following['profilePicture'] == null
                                  ? Text(
                                      following['username'][0].toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : null,
                            ),
                            title: Text(
                              following['username'] ?? 'Unknown User',
                              style: TextStyle(color: AppColors.orGrey),
                            ),
                            subtitle: Text(
                              following['nickname'] == 'Add nickname'
                                  ? ''
                                  : following['nickname'],
                              style: TextStyle(color: AppColors.orGrey),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(
                                  right: mediaQuery.screenWidth * 0.06),
                              child: Text('You'),
                            ))
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfile(userId: following['id'])));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    following['profilePicture'] ?? ''),
                                child: following['profilePicture'] == null
                                    ? Text(
                                        following['username'][0].toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    : null,
                              ),
                              title:
                                  Text(following['username'] ?? 'Unknown User'),
                              subtitle: Text(
                                  following['nickname'] == 'Add nickname'
                                      ? ''
                                      : following['nickname']),
                              trailing: FollowButton(userId: following['id']  , username: following['username'],),
                            ),
                          );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
