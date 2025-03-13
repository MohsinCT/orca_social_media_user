import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/fetch_datas_controller.dart';
import 'package:orca_social_media/view/screens/mobile/home_screen/upcoming_courses_details.dart';
import 'package:provider/provider.dart';

class UpcomeingCourseCarousel extends StatelessWidget {
  const UpcomeingCourseCarousel({super.key});

  @override 
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    final fetchUpcomingCourses = Provider.of<FetchUpcomingCourses>(context);
    final courses = fetchUpcomingCourses.upComingCourseList;

    if (courses.isEmpty) {
      Future.microtask(() => fetchUpcomingCourses.fetchUpcomingCourses());
    } 

    return courses.isNotEmpty
        ? CarouselSlider(
            options: CarouselOptions(
              height: mediaQuery.screenHeight * 0.16,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
            items: courses.map((course) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpComingCourseDetails(
                        courseName: course.upcomingCourseName,
                        courseDetails: course.upComingCourseDetails,
                      ),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: course.upComingCourseImage,
                        width: mediaQuery.screenWidth * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: AppColors.oRBlack.withOpacity(0.5),
                      ),
                      width: mediaQuery.screenWidth * 0.8,
                      child: Text(
                        course.upcomingCourseName,
                        style:  TextStyle(
                          color: AppColors.oRwhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
