import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/job_field_model.dart';

class JobFieldController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<JobField> _jobFields = [];
  bool _isLoading = false;

  List<JobField> get jobFields => _jobFields;
  bool get isLoading => _isLoading;
  Future<void> fetchJobFields() async {
    _isLoading = true;
    notifyListeners();

    try {
      // QuerySnapshot snapshot = await _firestore.collection('job_fields').get();
      // print("Fetching job fields...");

      // _jobFields = snapshot.docs.map((doc) {
      //   return JobField.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      // }).toList();
      print("A.");

      QuerySnapshot snapshot = await _firestore.collection('job_fields').get();
      print("b.");
      for (var doc in snapshot.docs) {
        print("Document ID: ${doc.id}");
        print("Document Data: ${doc.data()}"); // Check if any field is null
      }

      _jobFields = snapshot.docs.map((doc) {
        return JobField.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Job fields fetched successfully.");
    } catch (e) {
      print("Error fetching job fields: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
