import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/notification_controller.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_follow_button.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  final String userId;
  const NotificationScreen({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> fetchFollowers(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final List<dynamic> followersIds = userDoc.data()?['followers'] ?? [];

    if (followersIds.isEmpty) return [];

    // Batch fetching follower data to reduce Firestore calls
    final List<Map<String, dynamic>> followersData = [];
    final followersDocs = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('date' ,descending: true)
        .where(FieldPath.documentId, whereIn: followersIds)
        .get();

    for (var doc in followersDocs.docs) {
      followersData.add(doc.data());
    }
    return followersData;
  }

  @override
  Widget build(BuildContext context) {


    final notificationProvider =
      Provider.of<NotificationProvider>(context, listen: false);
  
  // Reset count when opening the screen
  WidgetsBinding.instance.addPostFrameCallback((_) {
    notificationProvider.resetNotificaionCount();
  });
    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyleading: true,
        centerTitle: true,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFollowers(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator(),);
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications yet', style: TextStyle(color: Colors.grey)),
            );
          }
          final notifications = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notify = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: notify['profilePicture'] != null
                      ? NetworkImage(notify['profilePicture'])
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
                ),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: notify['username'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " started following you."),
                    ],
                  ),
                ),
                subtitle: Text(
                  _formatTimestamp(notify['timestamp']), 
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: FollowButton(userId:notify['id'] ,),
                // trailing: ElevatedButton(
                //   onPressed: () {
                //     // Handle follow back
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     backgroundColor: Colors.blue,
                //   ),
                //   child: const Text(
                //     "Follow Back",
                //     style: TextStyle(color: Colors.white, fontSize: 12),
                //   ),
                // ),
              );
            },
          );
        },
      ),
    );
  }

  /// Shows shimmer effect while loading notifications
  

  /// Formats timestamp into readable format (e.g., "2h ago")
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Just now";
    final DateTime date = timestamp.toDate();
    final Duration difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inHours < 1) return "${difference.inMinutes}m ago";
    if (difference.inDays < 1) return "${difference.inHours}h ago";
    return "${difference.inDays}d ago";
  }
}
