import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/model/job_field_model.dart';
import 'package:flutter_application_1/view/users/question_page.dart';
import 'package:go_router/go_router.dart';

class JobPage extends StatelessWidget {
  final JobField selectedCategory;

  const JobPage({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final jobs = selectedCategory.jobs;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.go('/nav');
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: Text(selectedCategory.jobField),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: jobs.isEmpty
          ? Center(
              child: Text(
                "No jobs at the moment",
                style: TextStyles.h6,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final jobKey = jobs.keys.elementAt(index);
                final jobTitle = jobs[jobKey] ?? "Unknown Job";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionPage(jobId: jobTitle),
                        ));
                    // context.push('/questions', extra: jobTitle);
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        jobTitle,
                        style: TextStyles.h6,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
