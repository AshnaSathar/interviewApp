import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/course_model.dart';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CourseModel> _easyCourses = [];
  List<CourseModel> _mediumCourses = [];
  List<CourseModel> _hardCourses = [];

  List<CourseModel> get easyCourses => _easyCourses;
  List<CourseModel> get mediumCourses => _mediumCourses;
  List<CourseModel> get hardCourses => _hardCourses;

  /// Add a test question to a course
  Future<void> addTest(String courseId, String difficulty, String question,
      List<String> options, String correctAnswer) async {
    try {
      await _firestore
          .collection('courses')
          .doc(difficulty)
          .collection('course')
          .doc(courseId)
          .collection('questions')
          .add({
        'question': question,
        'options': options,
        'correctAnswer': correctAnswer,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("✅ Question Added Successfully");
    } catch (e) {
      print("❌ Error adding question: $e");
    }
  }

  /// Check if a course has at least one test
  Future<bool> hasTest(String difficulty, String courseId) async {
    try {
      QuerySnapshot testSnapshot = await _firestore
          .collection('courses')
          .doc(difficulty)
          .collection('course')
          .doc(courseId)
          .collection('questions')
          .limit(1)
          .get();
      return testSnapshot.docs.isNotEmpty;
    } catch (e) {
      print("❌ Error checking test: $e");
      return false;
    }
  }

  // Future<void> fetchCourses(String difficulty) async {
  //   print("Fetching courses for difficulty: $difficulty"); // Debug print

  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('courses')
  //       .where('difficulty', isEqualTo: difficulty)
  //       .get();

  //   List<CourseModel> courses = snapshot.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     print(
  //         "Fetched Course: ${data['title']} with difficulty ${data['difficulty']}"); // Debug print
  //     return CourseModel.fromFirestore(doc);
  //   }).toList();

  //   if (difficulty == 'easy') {
  //     _easyCourses = courses;
  //   } else if (difficulty == 'medium') {
  //     _mediumCourses = courses;
  //   } else if (difficulty == 'hard') {
  //     _hardCourses = courses;
  //   }

  //   notifyListeners();
  // }

  /// Fetch all courses for a given difficulty level
  ///
  String selected_difficulty = "";
  Future<void> fetchCourses(String difficulty) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .doc(difficulty)
          .collection('course')
          .get();

      List<CourseModel> courses = snapshot.docs.map((doc) {
        return CourseModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      // Debug print each fetched course
      for (var course in courses) {
        print(
            "Fetched Course: ${course.title} with difficulty ${course.difficulty}");
      }
      // selected_difficulty = difficulty;
      // print(difficulty);
      if (difficulty == 'easy') {
        _easyCourses = [...courses];
        print(_easyCourses);
      } else if (difficulty == 'medium') {
        _mediumCourses = [...courses];
      } else if (difficulty == 'hard') {
        _hardCourses = [...courses];
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error fetching courses: $e');
    }
  }

  Future<void> addCourse(String difficulty, CourseModel course) async {
    try {
      await _firestore
          .collection('courses')
          .doc(difficulty)
          .collection('course')
          .doc(course.id)
          .set(course.toMap());
      await fetchCourses(difficulty);
    } catch (e) {
      print('❌ Error adding course: $e');
    }
  }

  /// Delete a course and all its questions
  Future<void> deleteCourse(String difficulty, String courseId) async {
    try {
      // Delete all questions in the course
      QuerySnapshot questionsSnapshot = await _firestore
          .collection('courses')
          .doc(difficulty)
          .collection('course')
          .doc(courseId)
          .collection('questions')
          .get();
      for (var doc in questionsSnapshot.docs) {
        await doc.reference.delete();
      }
      // Delete course document
      await _firestore
          .collection('courses')
          .doc(difficulty)
          .collection('course')
          .doc(courseId)
          .delete();
      // Update local state
      if (difficulty == 'easy') {
        _easyCourses.removeWhere((course) => course.id == courseId);
      } else if (difficulty == 'medium') {
        _mediumCourses.removeWhere((course) => course.id == courseId);
      } else if (difficulty == 'hard') {
        _hardCourses.removeWhere((course) => course.id == courseId);
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error deleting course: $e');
    }
  }
}
