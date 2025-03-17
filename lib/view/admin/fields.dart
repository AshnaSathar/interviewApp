import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';

class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  final CollectionReference fieldsCollection =
      FirebaseFirestore.instance.collection('Fields');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Fields',
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fieldsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No fields found.'));
          }

          var fields = snapshot.data!.docs;

          return ListView.builder(
            itemCount: fields.length,
            itemBuilder: (context, index) {
              var field = fields[index];
              var fieldData = field.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(fieldData['name'] ?? 'No Name'),
                  subtitle: Text(fieldData['description'] ?? 'No Description'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'update') {
                        _showFieldDialog(
                          context,
                          fieldId: field.id,
                          initialName: fieldData['name'],
                          initialTitle: fieldData['title'],
                          initialIcon: fieldData['icon'],
                          initialDescription: fieldData['description'],
                        );
                      } else if (value == 'delete') {
                        _deleteField(field.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'update', child: Text('Update')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFieldDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show Add/Edit Dialog (updated to match Firestore structure: name, title, icon, description)
  void _showFieldDialog(BuildContext context,
      {String? fieldId,
      String? initialName,
      String? initialTitle,
      String? initialIcon,
      String? initialDescription}) {
    final nameController = TextEditingController(text: initialName ?? '');
    final titleController = TextEditingController(text: initialTitle ?? '');
    final iconController = TextEditingController(text: initialIcon ?? '');
    final descriptionController =
        TextEditingController(text: initialDescription ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fieldId == null ? 'Add Field' : 'Update Field'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Field Name'),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: iconController,
              decoration: const InputDecoration(labelText: 'Icon'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Field name cannot be empty')),
                );
                return;
              }

              final fieldData = {
                'name': nameController.text.trim(),
                'title': titleController.text.trim(),
                'icon': iconController.text.trim(),
                'description': descriptionController.text.trim(),
                'created_at': FieldValue.serverTimestamp(),
              };

              if (fieldId == null) {
                // Add new field
                await fieldsCollection.add(fieldData);
              } else {
                // Update existing field
                await fieldsCollection.doc(fieldId).update(fieldData);
              }

              Navigator.pop(context);
            },
            child: Text(fieldId == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete Field
  void _deleteField(String fieldId) async {
    await fieldsCollection.doc(fieldId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field deleted successfully')));
  }
}
