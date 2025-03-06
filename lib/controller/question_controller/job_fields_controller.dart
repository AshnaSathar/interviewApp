import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/job_field_model.dart';

class JobFieldController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<JobField> _fields = [];
  bool _isLoading = false;

  List<JobField> get fields => _fields;
  bool get isLoading => _isLoading;

  Future<void> fetchJobFields() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("hey");
      final snapshot = await _firestore.collection('Fields').get();
      _fields = snapshot.docs.map((doc) {
        return JobField.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching job fields: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
