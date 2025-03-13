import 'dart:convert';
import 'dart:developer';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/chat_controller.dart';
import 'package:orca_social_media/models/messages_model.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_message_card.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  final String userID;

  ChatScreen({
    super.key,
    required this.user,
    required this.userID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  List<Message> list = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final mediaQuery = MediaQueryHelper(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(
            automaticallyImplyleading: true,
            title: FutureBuilder<UserModel?>(
              future: userProvider.fetchUserById(widget.userID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text('somthing error'),
                  );
                }
                final user = snapshot.data!;
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilPicture),
                      radius: 18,
                    ),
                    SizedBox(width: mediaQuery.screenWidth * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
      
                  if (snapshot.hasError) {
                    return const Center(child: Text('Somthing went wrong!!!!!'));
                  }
      
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(
                      'Say Hii👋',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ));
                  }
                  final data = snapshot.data?.docs;
                  log('Data : ${jsonEncode(data![0].data())}');
      
                  list = data.map((e) => Message.fromJson(e.data())).toList();
      
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: list.length,
                      padding:
                          EdgeInsets.only(top: mediaQuery.screenHeight * 0.01),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MessageCard(message: list[index]);
                      },
                    );
                  } else {
                    return Center(
                      child: Text('Say hii'),
                    );
                  }
                },
              ),
            ),
            _chatInput(_messageController, widget.user,mediaQuery),
          
      
      
        
      
          ],
        ),
        //  Column(
        //   children: [
      
        //     Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: TextField(
        //               controller: _messageController,
        //               decoration: InputDecoration(
        //                 hintText: 'Type a message...',
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(20),
        //                   borderSide: BorderSide.none,
        //                 ),
        //                 filled: true,
        //                 fillColor: Colors.white,
        //                 contentPadding: const EdgeInsets.symmetric(
        //                     horizontal: 15, vertical: 10),
        //               ),
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: () async {
        //               if (_messageController.text.isNotEmpty) {
        //                 final message = Message(
        //                   text: _messageController.text,
        //                   senderId: senderId,
        //                   timestamp: DateTime.now(),
        //                   isRead: false,
        //                 );
      
        //                 await FirebaseFirestore.instance
        //                     .collection('messages')
        //                     .doc(chatId)
        //                     .collection('chats')
        //                     .add(message.toMap());
      
        //                 _messageController.clear();
        //               }
        //             },
        //             icon: const Icon(Icons.send, color: Colors.blue),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
  Widget _chatInput(TextEditingController controller, ChatUser user , MediaQueryHelper mediaQuery) {
  return Row(
    children: [
      Expanded(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              SizedBox(
                width: mediaQuery.screenWidth * 0.02,
              ),
              Expanded(
                  child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Type somthing.....', border: InputBorder.none),
              )),
              IconButton(onPressed: () {

              }, icon: Icon(Icons.image)),
              IconButton(onPressed: () {
                
              }, icon: Icon(Icons.camera)),
            ],
          ),
        ),
      ),
      MaterialButton(
        minWidth: 0,
        onPressed: () {
          if (controller.text.isNotEmpty) {
            APIs.sendMessage(user, controller.text);
            controller.text = '';
          }
        },
        child: Icon(
          Icons.send,
          size: 28,
        ),
      )
    ],
  );
}
}


