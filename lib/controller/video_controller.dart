import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VideoController extends ChangeNotifier {
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get videos => _videos;
  bool get isLoading => _isLoading;

  Future<void> fetchVideos() async {
    _isLoading = true;
    notifyListeners();

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('timestamp', descending: true)
          .get();
      _videos = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'url': doc['url'],
                'title': doc['title'] ?? '',
                'description': doc['description'] ?? '',
              })
          .toList();
    } catch (e) {
      debugPrint("Error fetching videos: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addVideo(String url, String title, String description) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('videos').add({
        'url': url,
        'title': title,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _videos.add({
        'id': docRef.id,
        'url': url,
        'title': title,
        'description': description,
      });
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding video: $e");
      throw e;
    }
  }

  Future<void> deleteVideo(String id) async {
    try {
      await FirebaseFirestore.instance.collection('videos').doc(id).delete();
      _videos.removeWhere((video) => video['id'] == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting video: $e");
      throw e;
    }
  }
}
