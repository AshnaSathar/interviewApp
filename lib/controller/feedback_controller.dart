import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitFeedback(double rating, String feedback) async {
    try {
      // Get current user info from FirebaseAuth.
      User? user = _auth.currentUser;
      // Use displayName if available; otherwise, fallback to email, or "Anonymous".
      String username = user?.displayName?.trim() ?? '';
      if (username.isEmpty) {
        username = user?.email ?? 'Anonymous';
      }

      await _firestore.collection('feedbacks').add({
        'username': username, // Save username automatically.
        'rating': rating,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Feedback submitted successfully.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error submitting feedback: $e");
    }
  }

  // Optionally, add a function to fetch all feedbacks (if needed)
  Future<List<Map<String, dynamic>>> fetchAllFeedbacks() async {
    try {
      final querySnapshot = await _firestore
          .collection('feedbacks')
          .orderBy('timestamp', descending: true)
          .get();
      List<Map<String, dynamic>> feedbacks = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return feedbacks;
    } catch (e) {
      debugPrint("Error fetching all feedbacks: $e");
      throw e;
    }
  }
}
