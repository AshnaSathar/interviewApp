import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/question_model.dart';

class QuestionController extends ChangeNotifier {
  List<QuestionModel> questions = [];
  bool isLoadingQuestions = false;

  Future<void> fetchQuestions(String jobId) async {
    isLoadingQuestions = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .where('jobId', isEqualTo: jobId)
          .get();

      questions = snapshot.docs.map((doc) {
        return QuestionModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      print("Fetched ${questions.length} questions for jobId: $jobId");
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      isLoadingQuestions = false;
      notifyListeners();
    }
  }
}
