import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/models/upcoming_courses_model.dart';

class FetchUpcomingCourses extends ChangeNotifier {
  // Use a typed list for better type safety
  List<UpcomingCourseModel> _upComingCourseList = [];
  List<UpcomingCourseModel> get upComingCourseList => _upComingCourseList;

  final CollectionReference upComingCourses =
      FirebaseFirestore.instance.collection('upComingCourse');

  FetchUpcomingCourses() {
    fetchUpcomingCourses();
  }

  /// Fetch upcoming courses with proper error handling and null checks
  Future<void> fetchUpcomingCourses() async {
    try {
      QuerySnapshot snapshot = await upComingCourses.get();

      // Parse each document into `UpcomingCourseModel`
      _upComingCourseList = snapshot.docs.map((doc) {
        try {
          return UpcomingCourseModel.fromDocument(doc);
        } catch (e) {
          log('Error parsing document ${doc.id}: $e');
          return null; // Skip documents that cause errors
        }
      }).where((course) => course != null).cast<UpcomingCourseModel>().toList();

      notifyListeners();
      log('Fetched ${_upComingCourseList.length} upcoming courses.');
    } catch (e) {
      log('Failed to fetch upcoming courses: $e');
    }
  }


  /// Live updates for real-time changes
  void listenToUpcomingCourses() {
    upComingCourses.snapshots().listen((QuerySnapshot snapshot) {
      try {
        _upComingCourseList = snapshot.docs.map((doc) {
          try {
            return UpcomingCourseModel.fromDocument(doc);
          } catch (e) {
            log('Error parsing document ${doc.id}: $e');
            return null;
          }
        }).where((course) => course != null).cast<UpcomingCourseModel>().toList();

        notifyListeners();
        log('Real-time update fetched ${_upComingCourseList.length} courses.');
      } catch (e) {
        log('Failed to process real-time snapshot: $e');
      }
    });
  }
}
