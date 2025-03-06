import 'package:cloud_firestore/cloud_firestore.dart';

class JobField {
  final String id;
  final String name;
  final String title;
  final String icon;
  final String description;
  final String type;
  final DateTime? createdAt; // Nullable DateTime to handle null case

  JobField({
    required this.id,
    required this.name,
    required this.title,
    required this.icon,
    required this.description,
    required this.type,
    this.createdAt, // Nullable here
  });

  factory JobField.fromMap(Map<String, dynamic> data, String id) {
    return JobField(
      id: id,
      name: data['name'] ?? 'Unknown',
      title: data['title'] ?? '',
      icon: data['icon'] ?? 'help_outline',
      description: data['description'] ?? '',
      type: data['type'] ?? 'Unknown',
      createdAt: (data['created_at'] != null)
          ? (data['created_at'] as Timestamp).toDate()
          : null, // Handle null safely
    );
  }
}
