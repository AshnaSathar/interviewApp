import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationProvider extends ChangeNotifier {
  bool _hasApplied = false;

  bool get hasApplied => _hasApplied;

  Future<void> checkApplicationStatus(String email, String vacancyId) async {
    try {
      print("Checking application status for user: $email, job: $vacancyId");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('applications') // Ensure correct collection name
          .where('candidateEmail', isEqualTo: email)
          .where('vacancyId', isEqualTo: vacancyId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("Application found in Firestore.");
        _hasApplied = true;
      } else {
        print("No application found.");
        _hasApplied = false;
      }

      notifyListeners();
    } catch (e) {
      print("Error checking application status: $e");
    }
  }
}
