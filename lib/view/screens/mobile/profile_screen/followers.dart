import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/followings_controller.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:provider/provider.dart';

class Followers extends StatelessWidget {
  final String userId;
  const Followers({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> fetchFollowers(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final List<dynamic> followersIds = userDoc.data()?['followers'] ?? [];

    List<Map<String, dynamic>> followersData = [];

    for (String followerId in followersIds) {
      final followerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(followerId)
          .get();

      if (followerDoc.exists) {
        followersData.add(followerDoc.data()!);
      }
    }
    return followersData;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final followingsProvider = Provider.of<FollowingsProvider>(context , listen: false);

    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyleading: true,
        title: const Text('Followers'),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: mediaQuery.screenHeight * 0.02,
          //     horizontal: mediaQuery.screenWidth * 0.02,
          //   ),
          //   // child: TextFormField(
          //   //   onChanged: (value) => 
          //   //   followingsProvider.filterFollowings(value),
          //   //   decoration: InputDecoration(
          //   //     prefixIcon: const Icon(Icons.search),
          //   //     hintText: 'Search',
          //   //     border: OutlineInputBorder(
          //   //       borderRadius: BorderRadius.circular(10),
          //   //     ),
          //   //   ),
          //   // ),
          // ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchFollowers(userId),
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
                  return const Center(child: Text('No followers found.'));
                }

                final followers = snapshot.data!;

                return ListView.builder(
                  itemCount: followers.length,
                  itemBuilder: (context, index) {
                    final follower = followers[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserProfile(userId: follower['id'])));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(follower['profilePicture'] ?? ''),
                          child: follower['profilePicture'] == null
                              ? Text(
                                  follower['username'][0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        title: Text(follower['username'] ?? 'Unknown User'),
                        subtitle: Text(follower['nickname'] == 'Add nickname'
                            ? ''
                            : follower['nickname']),
                            trailing: FollowButton(userId: follower['id'] ,),
                      ),
                    );
                  },
                
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
