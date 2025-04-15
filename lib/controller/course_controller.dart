import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCourseController extends ChangeNotifier {
  var selectedCourse;
  Future<void> subscribe_course({
    required String courseId,
    required String title,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      throw Exception("User not logged in.");
    }
    print("------------------------");
    print(selectedCourse.id);
    final email = currentUser.email!;
    final courseData = {
      'courseId': courseId,
      'title': title,
      'email': email,
      'addedAt': FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance.collection('my_course').add(courseData);
  }
}
