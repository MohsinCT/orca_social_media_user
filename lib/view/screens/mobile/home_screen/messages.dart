import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/controllers/users_story_controller.dart';
import 'package:orca_social_media/models/messages_model.dart';
import 'package:orca_social_media/utils/my_date_util.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/chat_screen.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  final String userId;
  final ChatUser user;

  MessagesScreen({
    super.key,
    required this.userId,
    required this.user,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyleading: true,
        title: Text('Messages'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F0FE), Color(0xFFDCE8F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ChangeNotifierProvider(
          create: (context) =>
              FollowingsController()..fetchFollowings(widget.userId),
          child: Consumer<FollowingsController>(
            builder: (context, followingsController, child) {
              if (followingsController.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final followings = followingsController.followings;

              if (followings.isEmpty) {
                return Center(
                  child: Text('No followings found.'),
                );
              }

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: followings.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final user = followings[index];

                  return StreamBuilder(
                    stream: followingsController.getLastMessage(
                      ChatUser(
                        id: user['id'],
                        firstName: user['username'] ?? 'Unknown User',
                      ),
                    ),
                    builder: (context, snapshot) {
                      Message? lastMessage;
                      bool isUnread = false;
                      // dynamic sentDateText ;
                      if (snapshot.hasData) {
                        final data = snapshot.data?.docs;
                        final list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (list.isNotEmpty) {
                          lastMessage = list[0];
                          isUnread = (lastMessage.read?.contains(
                                      followingsController.user.uid) ==
                                  false &&
                              lastMessage.fromId !=
                                  followingsController.user.uid);
                          //  sentDateText =  (lastMessage.read?.contains(followingsController.user.uid) == false);
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                                user['profilePicture'] ??
                                    ''), // Use profile picture URL if available
                            backgroundColor: Colors.grey.shade300,
                          ),
                          title: Text(
                            user['username'] ?? 'Unknown User',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          subtitle: Row(
                            children: [
                              isUnread
                                  ? Text.rich(
                                      TextSpan(
                                        text: lastMessage != null
                                            ? (lastMessage.msg.length > 5
                                                ? lastMessage.msg
                                                    .substring(0, 5)
                                                : lastMessage.msg)
                                            : 'Say',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          if (lastMessage != null &&
                                              lastMessage.msg.length > 5)
                                            WidgetSpan(
                                              child: Text(
                                                "......",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text.rich(
                                      TextSpan(
                                        text: lastMessage != null
                                            ? (lastMessage.msg.length > 10
                                                ? lastMessage.msg
                                                    .substring(0, 10)
                                                : lastMessage.msg)
                                            : 'Say Hii 👋',
                                        style: TextStyle(
                                          
                                          color: Colors.grey.shade600,
                                        ),
                                        children: [
                                          if (lastMessage != null &&
                                              lastMessage.msg.length > 10)
                                            WidgetSpan(
                                              child: Text(
                                                "......",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ), 
                          trailing: isUnread
                              ? Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent.shade400,
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              : lastMessage != null &&
                                      lastMessage.sent.isNotEmpty
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            'Send : ${MyDateUtil.getLastMessageTime(context: context, time: lastMessage.sent)}')
                                      ],
                                    )
                                  : null,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      user: ChatUser(
                                          id: user['id'],
                                          firstName: user['username'] ??
                                              'unknown User',
                                          profileImage:
                                              user['profilePicture'] ?? ''),
                                      userID: user['id'],
                                    )));
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
