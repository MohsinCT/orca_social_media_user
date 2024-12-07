import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final int itemCount;
  final String username;
  final String nickname;
  const UserList({super.key, required this.itemCount, required this.username, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context , index){
            return ListTile(
              leading: CircleAvatar(),
              title: Text(username),
              subtitle: Text(nickname),
            );

        })

      ],
    );
  }
}