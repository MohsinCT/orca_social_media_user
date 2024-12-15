import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: mediaQuery.screenHeight * 0.02,
          ),
          child: Container(
            width: mediaQuery.screenWidth,
            color: AppColors.oRLightGrey,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(),
                  title: Text(
                    'Username',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.screenWidth * 0.0,
                  ),
                  child: SizedBox(
                    width: mediaQuery.screenWidth,
                    height: mediaQuery.screenHeight * 0.4,
                    child: Image.asset(
                      'assets/aepic.jpg',
                      height: mediaQuery.screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaQuery.screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text("Username : Caption"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.03),
                  child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Sep 3 ,3:45 pm')),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Handle like button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        // Handle comment button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Handle share button press
                      },
                    ),
                    SizedBox(width: mediaQuery.screenWidth * 0.45),
                    IconButton(
                      icon: const Icon(Icons.bookmark_add_outlined),
                      onPressed: () {
                        // Handle bookmark button press
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
