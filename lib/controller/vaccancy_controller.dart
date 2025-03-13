import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';

class VacancyController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<VacancyModel> vacancies = [];

  Future<void> fetchVacancies() async {
    try {
      final querySnapshot = await _firestore.collection('vacancies').get();
      vacancies = querySnapshot.docs
          .map((doc) => VacancyModel.fromMap(doc.data(), id: doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching vacancies: $e");
    }
  }

  Future<void> addVacancy(VacancyModel vacancy) async {
    try {
      await _firestore.collection('vacancies').add(vacancy.toMap());
      fetchVacancies();
    } catch (e) {
      print("Error adding vacancy: $e");
    }
  }

  Future<void> updateVacancy(String id, VacancyModel updatedVacancy) async {
    try {
      await _firestore
          .collection('vacancies')
          .doc(id)
          .update(updatedVacancy.toMap());
      fetchVacancies();
    } catch (e) {
      print("Error updating vacancy: $e");
    }
  }

  Future<void> deleteVacancy(String id) async {
    try {
      await _firestore.collection('vacancies').doc(id).delete();
      fetchVacancies();
    } catch (e) {
      print("Error deleting vacancy: $e");
    }
  }
}
