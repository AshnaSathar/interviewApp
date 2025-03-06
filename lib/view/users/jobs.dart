import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/job_field_model.dart';
import 'package:flutter_application_1/model/job_model.dart';

class JobsListPage extends StatelessWidget {
  final String fieldId;
  final String fieldName;

  const JobsListPage(
      {super.key,
      required this.fieldId,
      required this.fieldName,
      required JobField jobField});

  Future<List<Job>> fetchJobs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Jobs')
        .where('fieldId', isEqualTo: fieldId)
        .get();

    return snapshot.docs.map((doc) {
      return Job.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$fieldName Jobs')),
      body: FutureBuilder<List<Job>>(
        future: fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final jobs = snapshot.data ?? [];

          if (jobs.isEmpty) {
            return const Center(child: Text('No jobs found.'));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return ListTile(
                title: Text(job.name),
                subtitle: Text(job.description),
              );
            },
          );
        },
      ),
    );
  }
}
