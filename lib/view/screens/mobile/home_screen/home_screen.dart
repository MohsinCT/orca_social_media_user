import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/fetch_datas_controller.dart';
import 'package:orca_social_media/controllers/notification_controller.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/messages.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/notification_screen.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/user_postview.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_carousel.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_story_circle.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  Future<void> _handleRefresh(BuildContext context) async {
    Provider.of<FetchUpcomingCourses>(context, listen: false);
  }

  Stream<int> fetchNotificationCount(String userId, BuildContext context) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) {
    final List<dynamic> followersIds = snapshot.data()?['followers'] ?? [];
    final int unreadNotifications = followersIds.length;

    // Update provider
    Provider.of<NotificationProvider>(context, listen: false)
        .updateNotificationCount(unreadNotifications);

    return unreadNotifications;
  });
}


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? currentUser = userProvider.getLoggedUserId();
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      appBar: CustomAppbar(
        centerTitle: true,
        title: Image.asset(
          AppImages.orcaLogoTrans,
          height: mediaQuery.screenHeight * 0.07, // 60
        ),
        actions: [
          Consumer<NotificationProvider>(
  builder: (context, notificationProvider, child) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            notificationProvider.resetNotificaionCount(); // Reset count when opening
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NotificationScreen(userId: currentUser!),
            ));
          },
          icon: Icon(Icons.notifications),
        ),
        if (notificationProvider.notificationCount > 0)
          Positioned(
            right: 8,
            top: 1,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                notificationProvider.notificationCount.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  },
),

          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MessagesScreen(
                          user: ChatUser(id: currentUser!),
                          userId: currentUser,
                        )));
              },
              icon: Icon(
                Icons.message,
              )),
        ],
      ),
      body: LiquidPullToRefresh(
        color: AppColors.oRBlack,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        onRefresh: () => _handleRefresh(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.screenHeight * 0.02),
                child: const Text(
                  'Upcoming Courses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Consumer<FetchUpcomingCourses>(builder: (context, fetch, child) {
                if (fetch.upComingCourseList.isEmpty) {
                  return Shimmer.fromColors(
                      baseColor: AppColors.oRGrey300f,
                      highlightColor: AppColors.oRGrey100,
                      child: Container(
                        width: mediaQuery.screenWidth * 0.8,
                        height: mediaQuery.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.oRGrey300f,
                        ),
                      ));
                } else {
                  return const UpcomeingCourseCarousel();
                }
              }),
              SizedBox(
                height: mediaQuery.screenHeight * 0.02,
              ),
              StoryCircle(
                userId: currentUser!,
              ),
              PostView(
                userId: currentUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
