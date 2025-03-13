import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/controller/application_controller.dart';
import 'package:flutter_application_1/model/application_model.dart';

class ViewJobApplicationsPage extends StatefulWidget {
  final String vacancyId;
  final String vacancyJobPosition;

  const ViewJobApplicationsPage({
    Key? key,
    required this.vacancyId,
    required this.vacancyJobPosition,
  }) : super(key: key);

  @override
  _ViewJobApplicationsPageState createState() =>
      _ViewJobApplicationsPageState();
}

class _ViewJobApplicationsPageState extends State<ViewJobApplicationsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch applications for the given vacancy.
    Provider.of<ApplicationController>(context, listen: false)
        .fetchApplicationsForVacancy(widget.vacancyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applications for ${widget.vacancyJobPosition}"),
      ),
      body: Consumer<ApplicationController>(
        builder: (context, appController, child) {
          if (appController.applications.isEmpty) {
            return Center(child: Text("No applications found for this job."));
          }
          return ListView.builder(
            itemCount: appController.applications.length,
            itemBuilder: (context, index) {
              final application = appController.applications[index];
              return Card(
                child: ListTile(
                  title: Text(application.candidateName),
                  subtitle: Text("Email: ${application.candidateEmail}"),
                  // trailing: IconButton(
                  //   icon: Icon(Icons.download, color: Colors.blue),
                  // onPressed: () {
                  //   Provider.of<ApplicationController>(context, listen: false)
                  //       .downloadResume(application.resumePath);
                  // },
                  // ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Application Details",
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  "Resume URL", application.resumePath),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close"),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
