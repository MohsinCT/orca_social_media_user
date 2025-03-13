import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:orca_social_media/constants/media_query.dart';

import 'package:orca_social_media/view/screens/mobile/network_screen/user_details.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';

class Followings extends StatelessWidget {
  final String userId;
  final TextEditingController searchController = TextEditingController();
   Followings({super.key, required this.userId});

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
    // final followingsProvider = Provider.of<FollowingsProvider>(context , listen : false);
    return Scaffold(
      appBar: CustomAppbar(
          automaticallyImplyleading: true, title: Text('Following')),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: mediaQuery.screenHeight * 0.02,
          //     horizontal: mediaQuery.screenWidth * 0.04,
          //   ),
          //   // child: TextFormField(
          //   //   onChanged: (a) {},
          //   //   decoration: InputDecoration(
          //   //     prefixIcon: const Icon(Icons.search),
          //   //     hintText: 'Search',
          //   //     border: OutlineInputBorder(
          //   //       borderRadius: BorderRadius.circular(10),
          //   //     ),
          //   //   ),
          //   // ),
          //   // child: Transform.scale(
          //   //   scale: 0.9,
          //   //   child: AnimatedSearchBar(
          //   //     label: 'Search',
          //   //     duration: Duration(milliseconds: 8000),
          //   //   ),
          //   // ),
          // ),
//           Expanded(
//   child: Consumer<FollowingsProvider>(
//     builder: (context, followingsProvider, child) {
//       if (followingsProvider.isLoading) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       if (followingsProvider.filteredFollowings.isEmpty) {
//         return const Center(child: Text('No user found'));
//       }

//       return ListView.builder(
//         itemCount: followingsProvider.filteredFollowings.length,
//         itemBuilder: (context, index) {
//           final following = followingsProvider.filteredFollowings[index];
//           return InkWell(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => UserProfile(userId: following['id']),
//               ));
//             },
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                   following['profilePicture'] ?? '',
//                 ),
//                 child: following['profilePicture'] == null
//                     ? Text(
//                         following['username'][0].toUpperCase(),
//                         style: TextStyle(color: AppColors.oRwhite),
//                       )
//                     : null,
//               ),
//               title: Text(following['username'] ?? 'Unknown User'),
//               subtitle: Text(
//                 following['nickname'] == 'Add nickname'
//                     ? ''
//                     : following['nickname'],
//               ),
//               trailing: FollowButton(userId: userId),
//             ),
//           );
//         },
//       );
//     },
//   ),
// ),

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
                        trailing: FollowButton(userId: follower['id'], username: follower['username'],),
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
