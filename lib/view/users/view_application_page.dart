import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controller/application_controller.dart';
import 'package:flutter_application_1/model/application_model.dart';

class ViewMyApplications extends StatefulWidget {
  // Pass the candidate's email to filter only their applications.
  final String candidateEmail;

  const ViewMyApplications({Key? key, required this.candidateEmail})
      : super(key: key);

  @override
  State<ViewMyApplications> createState() => _ViewMyApplicationsState();
}

class _ViewMyApplicationsState extends State<ViewMyApplications> {
  @override
  void initState() {
    super.initState();
    Provider.of<ApplicationController>(context, listen: false)
        .fetchMyApplications(widget.candidateEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Applications"),
      ),
      body: Consumer<ApplicationController>(
        builder: (context, appController, child) {
          if (appController.applications.isEmpty) {
            return const Center(child: Text("No applications submitted."));
          }
          return ListView.builder(
            itemCount: appController.applications.length,
            itemBuilder: (context, index) {
              ApplicationModel application = appController.applications[index];
              return Card(
                child: ListTile(
                  title: Text(application.candidateName),
                  subtitle: Text("For Vacancy ID: ${application.vacancyId}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          "Application Details",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                  "Candidate Name", application.candidateName),
                              _buildDetailRow(
                                  "Email", application.candidateEmail),
                              _buildDetailRow(
                                  "Phone", application.candidatePhone),
                              _buildDetailRow(
                                  "Vacancy ID", application.vacancyId),
                              _buildDetailRow(
                                  "Resume Path", application.resumePath),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
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
            ),
          ],
        ),
      ),
    );
  }
}
