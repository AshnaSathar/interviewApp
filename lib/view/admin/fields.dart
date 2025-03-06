import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(title: const Text('Manage Fields')),
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
                          initialDescription: fieldData['description'],
                          initialType: fieldData['type'],
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

  // Show Add/Edit Dialog
  void _showFieldDialog(BuildContext context,
      {String? fieldId,
      String? initialName,
      String? initialDescription,
      String? initialType}) {
    final nameController = TextEditingController(text: initialName ?? '');
    final descriptionController =
        TextEditingController(text: initialDescription ?? '');
    String selectedType = initialType ?? 'Text'; // Default type

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
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['Text', 'Number', 'Dropdown'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                selectedType = value!;
              },
              decoration: const InputDecoration(labelText: 'Field Type'),
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
                'description': descriptionController.text.trim(),
                'type': selectedType,
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
