import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/model/job_model.dart';
import 'package:flutter_application_1/view/users/question_page.dart';

class AllJobsPage extends StatefulWidget {
  const AllJobsPage({Key? key}) : super(key: key);

  @override
  State<AllJobsPage> createState() => _AllJobsPageState();
}

class _AllJobsPageState extends State<AllJobsPage> {
  // Predefined list of images to assign to each job.
  final List<String> images = [
    "assets/images/img1.jpg",
    "assets/images/img2.jpg",
    "assets/images/img3.jpg",
    "assets/images/img4.jpg",
    "assets/images/img5.jpg",
    "assets/images/img6.jpg",
  ];

  /// Fetches all jobs from Firestore, and assigns an image from the list.
  Future<List<Job>> fetchAllJobs() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('jobs').get();

    return snapshot.docs.asMap().entries.map((entry) {
      int index = entry.key;
      var doc = entry.value;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Assign an image from the list (cycling through the list)
      data['image'] = images[index % images.length];
      return Job.fromMap(data, doc.id);
    }).toList();
  }

  /// Helper function to format a DateTime.
  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Jobs',
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: ColorConstants.primaryColor,
      ),
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
                  // leading: Image.asset(
                  //   job['image'],
                  //   fit: BoxFit.cover,
                  // ),
                  title: Text(
                    job.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.description),
                      const SizedBox(height: 4),
                      // Text(
                      //   'Posted on: ${job.createdAt != null ? _formatDate(job.createdAt!) : 'Unknown'}',
                      //   style:
                      //       const TextStyle(fontSize: 12, color: Colors.grey),
                      // ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(jobId: job.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
