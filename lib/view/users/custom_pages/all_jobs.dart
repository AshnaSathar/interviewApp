import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/job_model.dart';

class AllJobsPage extends StatelessWidget {
  const AllJobsPage({super.key});

  Future<List<Job>> fetchAllJobs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Jobs')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return Job.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Jobs')),
      body: FutureBuilder<List<Job>>(
        future: fetchAllJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final jobs = snapshot.data ?? [];

          if (jobs.isEmpty) {
            return const Center(child: Text('No jobs available.'));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    job.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.description),
                      const SizedBox(height: 4),
                      Text(
                        'Posted on: ${job.createdAt != null ? _formatDate(job.createdAt!) : 'Unknown'}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
