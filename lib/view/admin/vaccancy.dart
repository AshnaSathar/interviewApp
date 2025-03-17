import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/vaccancy_controller.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';
import 'package:flutter_application_1/view/admin/viewJobApplicationsPage.dart';
import 'package:provider/provider.dart';
import 'add_vacancy.dart';

class VacancyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vacancies',
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: Provider.of<VacancyController>(context, listen: false)
            .fetchVacancies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          return Consumer<VacancyController>(
            builder: (context, vacancyController, child) {
              if (vacancyController.vacancies.isEmpty) {
                return Center(child: Text('Nothing to display'));
              }
              return ListView.builder(
                itemCount: vacancyController.vacancies.length,
                itemBuilder: (context, index) {
                  final vacancy = vacancyController.vacancies[index];
                  return Card(
                    child: ListTile(
                      onTap: () => _showVacancyDetails(context, vacancy),
                      title: Text(vacancy.jobPosition),
                      subtitle: Text(vacancy.companyName),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'update') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddVacancyPage(vacancy: vacancy),
                              ),
                            );
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirm Delete',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                content: Text(
                                    'Are you sure you want to delete this vacancy?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<VacancyController>(context,
                                              listen: false)
                                          .deleteVacancy(vacancy.id);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          } else if (value == 'view_application') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewJobApplicationsPage(
                                  vacancyId: vacancy.id,
                                  vacancyJobPosition: vacancy.jobPosition,
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'update', child: Text('Update')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                          PopupMenuItem(
                              value: 'view_application',
                              child: Text('View Application')),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddVacancyPage()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showVacancyDetails(BuildContext context, VacancyModel vacancy) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Vacancy Details",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                _buildDetailRow(
                    "Preferred Skills", vacancy.preferredSkills.join(', ')),
                _buildDetailRow(
                    "Language Preferred", vacancy.languagePreferred.join(', ')),
                _buildDetailRow("Experience", vacancy.experience.toString()),
                _buildDetailRow("Age From", vacancy.ageFrom?.toString() ?? ''),
                _buildDetailRow("Age To", vacancy.ageTo?.toString() ?? ''),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
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
            )
          ],
        ),
      ),
    );
  }
}
