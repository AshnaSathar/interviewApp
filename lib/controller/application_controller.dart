import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/application_model.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'dart:io' as io show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApplicationController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ApplicationModel> applications = [];

  Future<void> fetchApplications() async {
    try {
      final querySnapshot = await _firestore.collection('applications').get();
      applications = querySnapshot.docs
          .map((doc) => ApplicationModel.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching applications: $e");
    }
  }

  Future<void> fetchMyApplications(String candidateEmail) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('candidateEmail', isEqualTo: candidateEmail)
          .get();
      applications = querySnapshot.docs
          .map((doc) => ApplicationModel.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching my applications: $e");
    }
  }

  Future<void> submitApplication(ApplicationModel application) async {
    try {
      await _firestore.collection('applications').add(application.toMap());
      await fetchApplications();
    } catch (e) {
      print("Error submitting application: $e");
      throw e;
    }
  }

  Future<void> fetchApplicationsForVacancy(String vacancyId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('vacancyId', isEqualTo: vacancyId)
          .get();
      applications = querySnapshot.docs
          .map((doc) => ApplicationModel.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching applications for vacancy: $e");
    }
  }

  Future<void> downloadResume(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not open URL: $url");
    }
  }
}
