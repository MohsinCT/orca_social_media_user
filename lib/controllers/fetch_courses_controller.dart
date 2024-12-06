import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/models/course_category_model.dart';
import 'package:orca_social_media/models/course_model.dart';
import 'package:orca_social_media/models/lesson_model.dart';

class FetchCoursesController extends ChangeNotifier {
  // List of all courses
  List<CourseModel> courseList = [];

  // List of categories for a specific course
  List<CourseCategoryModel> categoryList = [];

  FetchCoursesController() {
    fetchNewCourses(); // Automatically fetch courses on initialization
  }

  /// Fetch the list of new courses from Firestore
  Future<void> fetchNewCourses() async {
    try {
      log('Fetching all new courses...');
      // Fetch all documents from the 'NewCourse' collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('NewCourse').get();

      // Clear the current course list to avoid duplicates
      courseList.clear();

      // Convert Firestore documents to CourseModel instances
      courseList = querySnapshot.docs
          .map((doc) => CourseModel.fromDocument(doc))
          .toList();

      log('Fetched ${courseList.length} courses successfully');
      notifyListeners(); // Notify listeners about the changes
    } catch (e) {
      log('Error fetching available courses: $e'); // Log any errors
    }
  }

  /// Fetch the categories for a specific course by ID
  Future<void> fetchCategories(String courseId) async {
    try {
      log('Fetching categories for course $courseId...');
      // Reference to the specific course document
      DocumentReference courseRef =
          FirebaseFirestore.instance.collection('NewCourse').doc(courseId);

      // Reference to the 'Categories' subcollection
      CollectionReference categoryCollection = courseRef.collection('Categories');

      // Fetch all documents from the 'Categories' subcollection
      QuerySnapshot querySnapshot = await categoryCollection.get();

      // Clear the current category list to avoid duplicates
      categoryList.clear();

      // Convert Firestore documents to CourseCategoryModel instances
      categoryList = querySnapshot.docs
          .map((doc) => CourseCategoryModel.fromDocument(doc))
          .toList();

      log('Fetched ${categoryList.length} categories for course $courseId');
      notifyListeners(); // Notify listeners about the changes
    } catch (e) {
      log('Error fetching categories for course $courseId: $e'); // Log any errors
    }
  }


  Stream<List<LessonModel>> fetchLessons(String courseId, String categoryId) {
    return FirebaseFirestore.instance
        .collection('NewCourse')
        .doc(courseId)
        .collection('Categories')
        .doc(categoryId)
        .collection('Lessons')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => LessonModel.fromDocument(doc)).toList();
    });
  }

  
  @override
  void dispose() {
    // Cleanup resources if needed
    super.dispose();
  }
}
