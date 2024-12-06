import 'package:flutter/material.dart';

class UpComingCourseDetails extends StatelessWidget {
  final String courseName;
  final String courseDetails;
  // Single course passed to this screen
  
  const UpComingCourseDetails({super.key, required this.courseName , required this.courseDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Display the course name in the AppBar
        title: Text( courseName),
      ),
      body: Text(
        courseDetails,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
