import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/users/job_details_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controller/vaccancy_controller.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';

class VacancyList extends StatefulWidget {
  const VacancyList({Key? key}) : super(key: key);

  @override
  State<VacancyList> createState() => _VacancyListState();
}

class _VacancyListState extends State<VacancyList> {
  @override
  void initState() {
    super.initState();
    // Fetch vacancies when the page loads.
    Provider.of<VacancyController>(context, listen: false).fetchVacancies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vacancies"),
      ),
      body: Consumer<VacancyController>(
        builder: (context, vacancyController, child) {
          if (vacancyController.vacancies.isEmpty) {
            return const Center(child: Text("No vacancies found."));
          }
          return ListView.builder(
            itemCount: vacancyController.vacancies.length,
            itemBuilder: (context, index) {
              VacancyModel vacancy = vacancyController.vacancies[index];
              return Card(
                child: ListTile(
                  title: Text(vacancy.jobPosition),
                  subtitle: Text(vacancy.companyName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailPage(vacancy: vacancy),
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
