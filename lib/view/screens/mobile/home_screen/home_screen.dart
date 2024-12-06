import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/fetch_datas_controller.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_carousel.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_story_circle.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    Provider.of<FetchUpcomingCourses>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    // List of items with corresponding names for the circles
    final List<String> circleItems = [
      'Your Story',
      'Jane Smith',
      'Alice Johnson',
      'Michael Brown',
      'Chris Lee',
      'Emma Davis',
      'David Wilson'
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          'assets/orca_logo_trans.png',
          height: 60,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          Padding(
            padding: EdgeInsets.only(right: mediaQuery.screenWidth * 0.03),
            child:
                IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        color: AppColors.oRLightGrey,
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
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: mediaQuery.screenWidth * 0.8,
                        height: mediaQuery.screenHeight * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                      ));
                } else {
                  return const UpcomeingCourseCarousel();
                }
              }),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.screenHeight * 0.02,
                ),
                child: StoryCircle(circleItems: circleItems),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: circleItems.length,
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
                              circleItems[index],
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
                              child: Text(
                                  "${circleItems[index]} : This part of my life called a HUGE CHANGE....."),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: mediaQuery.screenWidth * 0.03),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
