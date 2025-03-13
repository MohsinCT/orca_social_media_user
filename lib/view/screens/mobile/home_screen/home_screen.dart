import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/fetch_datas_controller.dart';

import 'package:orca_social_media/view/screens/mobile/home_screen/messages.dart';
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
          height: 60,
        ),
        actions: [
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
              ))
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
