import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/models/course_model.dart';
import 'package:shimmer/shimmer.dart'; // Update the path to your model if needed

class CustomCourseGridView extends StatelessWidget {
  final List<CourseModel> courses;
  final Function(String courseId) onCoursePressed;

  const CustomCourseGridView({
    super.key,
    required this.courses,
    required this.onCoursePressed,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return GridView.builder(
      itemCount: courses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          color: AppColors.oRLightGrey,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.screenHeight * 0.02),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: mediaQuery.screenWidth * 0.9,
                    height: mediaQuery.screenHeight * 0.14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade800,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: course.imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CachedNetworkImage(
                        imageUrl: course.imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child:  Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.shade800),
                            )),
                        errorWidget: (context, url, error) => Icon(
                          Icons.broken_image,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.broken_image,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery.screenHeight * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    course.courseName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.oRBlack,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: (){
                        onCoursePressed(course.id);
                      },
                      child: const Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
