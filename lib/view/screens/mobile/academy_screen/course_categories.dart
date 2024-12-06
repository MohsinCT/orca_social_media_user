import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/fetch_courses_controller.dart';

import 'package:orca_social_media/view/screens/mobile/academy_screen/lessions.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class CourseCategories extends StatelessWidget {
  final String courseId;
  
  // Added courseId as a constructor parameter

  const CourseCategories({super.key, required this.courseId, });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => FetchCoursesController()..fetchCategories(courseId),
        child: Consumer<FetchCoursesController>(
          builder: (context , fetchCatCourses , child){
            final courseCategories = fetchCatCourses.categoryList;

            if(courseCategories.isEmpty){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
                  itemCount: courseCategories.length, // Use dynamic itemCount
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {

                    final category = courseCategories[index];
                    return GestureDetector(
                      child: Card(
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
                                    imageUrl: category.categoryImage, // Use actual image URL
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.grey.shade800),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: mediaQuery.screenHeight * 0.01,
                                horizontal: mediaQuery.screenWidth * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.categoryName,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Lessons ${category.lessonCount}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  category.categoryCourseName, // Display category name here
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
                                    onPressed: () {
                                      // Navigate to LessonScreen with the category ID
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonScreen(courseId: courseId, categoryId: category.id)));
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
                      ),
                    );
                  },
          );
          },
      
        ),
      )
            );
          }

  }

