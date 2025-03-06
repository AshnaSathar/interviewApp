import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/question_model.dart';

class QuestionController extends ChangeNotifier {
  List<QuestionModel> questions = [];
  List<String> jobs = [];
  List<String> fields = [];

  bool isLoadingQuestions = false;
  bool isLoadingJobs = false;
  bool isLoadingFields = false;

  Future<void> fetchJobs() async {
    isLoadingJobs = true;
    notifyListeners();

    try {
      var snapshot = await FirebaseFirestore.instance.collection('jobs').get();

      jobs = snapshot.docs
          .map((doc) => doc.id)
          .toList(); // Assuming job IDs are useful
      print("Fetched ${jobs.length} jobs");
    } catch (e) {
      print("Error fetching jobs: $e");
    } finally {
      isLoadingJobs = false;
      notifyListeners();
    }
  }

  Future<void> fetchFields(String jobId) async {
    isLoadingFields = true;
    notifyListeners();

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('fields')
          .where('jobId', isEqualTo: jobId)
          .get();

      fields = snapshot.docs
          .map((doc) => doc.id)
          .toList(); // Assuming field IDs are useful
      print("Fetched ${fields.length} fields for job: $jobId");
    } catch (e) {
      print("Error fetching fields: $e");
    } finally {
      isLoadingFields = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuestions(String jobId) async {
    isLoadingQuestions = true;
    notifyListeners();

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('fields')
          .doc(jobId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        List<QuestionModel> loadedQuestions = [];

        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            loadedQuestions.add(QuestionModel.fromMap(value));
          }
        });

        questions = loadedQuestions;
        print("Fetched ${questions.length} questions for job: $jobId");
      } else {
        print("No questions found for job: $jobId");
      }
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      isLoadingQuestions = false;
      notifyListeners();
    }
  }
}
