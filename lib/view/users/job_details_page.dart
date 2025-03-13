import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';
import 'package:flutter_application_1/view/users/application_job_post.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(vacancy.jobPosition),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplyForPostPage(vacancy: vacancy),
                  ),
                );
              },
              child: const Text("Apply for the Job"),
            )
          ],
        ),
      ),
    );
  }
}
