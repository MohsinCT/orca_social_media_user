import 'package:flutter/material.dart';

import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/fetch_courses_controller.dart';
import 'package:orca_social_media/view/screens/mobile/academy_screen/course_categories.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_gridview_builder.dart';
import 'package:provider/provider.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      appBar: CustomAppbar(title: Text('Academy')),
      body: Column(
        children: [
          // Padding(
          //   padding:
          //       EdgeInsets.symmetric(vertical: mediaQuery.screenHeight * 0.02),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.black, // Black button
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(25),
          //         side: const BorderSide(color: Colors.white), // White border
          //       ),
          //     ),
          //     onPressed: () {
          //       // Handle enrolled courses action
          //     },
          //     child: const Text(
          //       'Enrolled Courses',
          //       style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white, // White text
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
              child: ChangeNotifierProvider(
            create: (context) => FetchCoursesController(),
            child: Consumer<FetchCoursesController>(
                builder: (context, fetchCourses, child) {
              final course = fetchCourses.courseList;

              return CustomCourseGridView(
                courses: course,
                onCoursePressed: (courseId) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  CourseCategories(
                            courseId: courseId,
                          )));
                },
              );
            }),
          )),
        ],
      ),
    );
  }
}
