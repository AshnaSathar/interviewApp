import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String name;
  final String description;
  final String fieldId;
  final DateTime? createdAt;

  Job({
    required this.id,
    required this.name,
    required this.description,
    required this.fieldId,
    this.createdAt,
  });

  factory Job.fromMap(Map<String, dynamic> data, String id) {
    return Job(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fieldId: data['fieldId'] ?? '',
      createdAt: (data['created_at'] != null)
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }
}
