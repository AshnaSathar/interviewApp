import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controller/application_controller.dart';
import 'package:flutter_application_1/model/application_model.dart';

class ViewMyApplications extends StatefulWidget {
  final String candidateEmail;

  const ViewMyApplications({Key? key, required this.candidateEmail})
      : super(key: key);

  @override
  State<ViewMyApplications> createState() => _ViewMyApplicationsState();
}

class _ViewMyApplicationsState extends State<ViewMyApplications> {
  bool _isFetched = false;

  final List<Color> pastelColors = [
    Color.fromARGB(255, 255, 246, 248),
    Color.fromARGB(255, 245, 252, 255),
    Color.fromARGB(255, 230, 255, 230),
    Color.fromARGB(255, 255, 254, 216),
    Color.fromARGB(255, 255, 239, 255),
    Color.fromARGB(255, 255, 242, 223),
    Color.fromARGB(255, 231, 255, 252),
    Color.fromARGB(255, 229, 229, 255),
    Color.fromARGB(255, 255, 244, 234),
    Color.fromARGB(255, 233, 255, 255),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetched) {
      Provider.of<ApplicationController>(context, listen: false)
          .fetchMyApplications(widget.candidateEmail)
          .then((_) {
        print("Fetched applications for ${widget.candidateEmail}");
      }).catchError((error) {
        print("Error fetching applications: $error");
      });
      _isFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "My Applications",
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<ApplicationController>(
        builder: (context, appController, child) {
          print("Current applications: ${appController.applications}");
          if (appController.applications.isEmpty) {
            return const Center(child: Text("No applications submitted."));
          }
          return ListView.builder(
            itemCount: appController.applications.length,
            itemBuilder: (context, index) {
              ApplicationModel application = appController.applications[index];
              return Card(
                color: pastelColors[index % pastelColors.length],
                child: ListTile(
                  title: Text(
                    application.candidateName,
                    style: TextStyles.normalText,
                  ),
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
