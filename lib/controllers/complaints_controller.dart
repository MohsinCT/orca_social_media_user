import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/complaint_model.dart';

class ComplaintController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a complaint to the user's subcollection
  Future<void> addComplaint(String userId, ComplaintModel complaint) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('complaints')
          .doc(complaint.id)
          .set(complaint.toMap());

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding complaint: $e');
    }
  }

  // Function to delete a complaint from the user's subcollection
  Future<void> deleteComplaint(String userId, String complaintId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('complaints')
          .doc(complaintId)
          .delete();

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting complaint: $e');
    }
  }

  // Function to fetch complaints (optional)
  Future<List<ComplaintModel>> fetchComplaints(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('complaints')
          .get();

      return snapshot.docs
          .map((doc) => ComplaintModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching complaints: $e');
      return [];
    }
  }
}
