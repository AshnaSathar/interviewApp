import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/job_application_controller.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';
import 'package:flutter_application_1/view/users/application_job_post.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobDetailPage extends StatelessWidget {
  final VacancyModel vacancy;

  const JobDetailPage({Key? key, required this.vacancy}) : super(key: key);

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? ""; // Get the logged-in user's ID
    final emailId = user?.email ?? ""; // Fetch the logged-in user's email
    final jobId = vacancy.id; // Assuming `id` is a property in VacancyModel

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          vacancy.jobPosition,
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow("Job Position", vacancy.jobPosition),
            _buildDetailRow("Company Name", vacancy.companyName),
            _buildDetailRow("Location", vacancy.location),
            _buildDetailRow("Company Address", vacancy.companyAddress),
            _buildDetailRow("Phone Number", vacancy.phoneNumber),
            _buildDetailRow("Email", vacancy.email),
            _buildDetailRow("Salary", vacancy.salary.toString()),
            _buildDetailRow("Place", vacancy.place),
            _buildDetailRow("Description", vacancy.description),
            _buildDetailRow("Job Type", vacancy.jobType),
            _buildDetailRow("Experience", vacancy.experience.toString()),
            _buildDetailRow("Age From", vacancy.ageFrom?.toString() ?? ""),
            _buildDetailRow("Age To", vacancy.ageTo?.toString() ?? ""),
            _buildDetailRow(
                "Preferred Skills", vacancy.preferredSkills.join(', ')),
            _buildDetailRow(
                "Language Preferred", vacancy.languagePreferred.join(', ')),
            _buildDetailRow("Your Email ID", emailId), // Display user's email
            const SizedBox(height: 24),

            // Use Consumer to check application status
            Consumer<JobApplicationProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        provider.hasApplied ? Colors.grey : Colors.red),
                  ),
                  onPressed: provider.hasApplied
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "You have already applied for this job!"),
                            ),
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ApplyForPostPage(vacancy: vacancy),
                            ),
                          );
                        },
                  child: Text(
                    provider.hasApplied
                        ? "Already Applied"
                        : "Apply for the Job",
                    style: TextStyles.normalText.copyWith(color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
