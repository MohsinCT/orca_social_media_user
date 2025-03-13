import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/chat_controller.dart';
import 'package:orca_social_media/models/messages_model.dart';
import 'package:orca_social_media/utils/my_date_util.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});
 
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage(context)
        : _blueMessage(context);
  }

  Widget _blueMessage(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    if(widget.message.read!.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      log('message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                color: Color.fromARGB(255, 221, 245, 255)),
            padding: EdgeInsets.all(mediaQuery.screenWidth * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mediaQuery.screenWidth * 0.04,
                vertical: mediaQuery.screenHeight * 0.01),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mediaQuery.screenWidth * 0.04),
          child: Text(
            MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    );
  }

 Widget _greenMessage(BuildContext context) {
  final mediaQuery = MediaQueryHelper(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.04),
        child: Text(
          MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ),
      Flexible(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: Color.fromARGB(255, 218, 255, 176),
              ),
              padding: EdgeInsets.all(mediaQuery.screenWidth * 0.04),
              margin: EdgeInsets.symmetric(
                horizontal: mediaQuery.screenWidth * 0.09,
                vertical: mediaQuery.screenHeight * 0.01,
              ),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
             Positioned(
              bottom: 4,  // Fine-tune positioning
              right: 2, // Slightly outside for better alignment
              child: Icon(
                Icons.done,
                color: Colors.grey,
                size: 16, // Reduced icon size
              ),
            ),

            if(widget.message.read!.isNotEmpty)
            Positioned(
              bottom: 4,  // Fine-tune positioning
              right: 2, // Slightly outside for better alignment
              child: Icon(
                Icons.done_all,
                color: Colors.blue,
                size: 16, // Reduced icon size
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

}
