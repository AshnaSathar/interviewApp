import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/model/job_model.dart';
import 'package:flutter_application_1/view/users/question_page.dart';

class JobsListPage extends StatelessWidget {
  final String fieldId;

  const JobsListPage({
    super.key,
    required this.fieldId,
  });

  Future<List<Job>> fetchJobs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .where('fieldId', isEqualTo: fieldId)
        .get();

    return snapshot.docs.map((doc) {
      return Job.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Text(
          'Jobs List',
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
      ),
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
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionPage(jobId: job.id),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        job.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(job.description),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
