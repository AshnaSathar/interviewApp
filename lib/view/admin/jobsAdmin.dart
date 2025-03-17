import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';

class JobsPageAdmin extends StatefulWidget {
  const JobsPageAdmin({super.key});

  @override
  State<JobsPageAdmin> createState() => _JobsPageAdminState();
}

class _JobsPageAdminState extends State<JobsPageAdmin> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? selectedFieldId; // To select the Field (IT, Medical, etc.)

  List<Map<String, dynamic>> fields = []; // To hold fields from Firestore

  @override
  void initState() {
    super.initState();
    fetchFields();
  }

  Future<void> fetchFields() async {
    var snapshot = await FirebaseFirestore.instance.collection('Fields').get();
    setState(() {
      fields = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
              })
          .toList();
    });

    // Print the fields to check if data is loaded
    print('Fetched Fields: $fields');
  }

  Future<void> createOrUpdateJob(
      {String? jobId, String? selectedFieldId}) async {
    if (selectedFieldId == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final data = {
      'name': _nameController.text,
      'description': _descController.text,
      'fieldId': selectedFieldId,
      'created_at': FieldValue.serverTimestamp(),
    };

    if (jobId == null) {
      await FirebaseFirestore.instance.collection('jobs').add(data);
    } else {
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(jobId)
          .update(data);
    }

    _nameController.clear();
    _descController.clear();
    selectedFieldId = null;
    fetchFields();
    Navigator.pop(context);
  }

  Future<void> deleteJob(String jobId) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
    fetchFields();
  }

  void showJobDialog({
    String? jobId,
    String? initialName,
    String? initialDesc,
    String? initialFieldId,
  }) {
    _nameController.text = initialName ?? '';
    _descController.text = initialDesc ?? '';

    showDialog(
      context: context,
      builder: (context) {
        String? localSelectedFieldId = initialFieldId;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(jobId == null ? 'Add Job' : 'Edit Job'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Job Name'),
                    ),
                    TextField(
                      controller: _descController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    DropdownButtonFormField<String>(
                      value: localSelectedFieldId,
                      decoration: const InputDecoration(labelText: 'Field'),
                      items: fields.map<DropdownMenuItem<String>>((field) {
                        return DropdownMenuItem<String>(
                          value: field['id'] as String,
                          child: Text(field['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          localSelectedFieldId = value;
                          print('Selected field ID: $localSelectedFieldId');
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    createOrUpdateJob(
                      jobId: jobId,
                      selectedFieldId: localSelectedFieldId,
                    );
                  },
                  child: Text(jobId == null ? 'Create' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Jobs',
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No jobs found'));
          }

          var jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              var jobData = job.data();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(jobData['name']),
                  subtitle: Text(jobData['description'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showJobDialog(
                            jobId: job.id,
                            initialName: jobData['name'],
                            initialDesc: jobData['description'],
                            initialFieldId: jobData['fieldId'],
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteJob(job.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showJobDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
