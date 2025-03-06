import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/question_controller/job_fields_controller.dart';
import 'package:flutter_application_1/view/admin/jobsAdmin.dart';
import 'package:flutter_application_1/view/users/jobs.dart';
import 'package:provider/provider.dart';
import '../../model/job_field_model.dart';

class FullCategoryPage extends StatefulWidget {
  const FullCategoryPage({super.key});

  @override
  State<FullCategoryPage> createState() => _FullCategoryPageState();
}

class _FullCategoryPageState extends State<FullCategoryPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<JobFieldController>(context, listen: false).fetchJobFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobFieldController = Provider.of<JobFieldController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: jobFieldController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: jobFieldController.fields.length,
              itemBuilder: (context, index) {
                final field = jobFieldController.fields[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobsListPage(
                          jobField: field,
                          fieldId: '',
                          fieldName: '',
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconByName(field.icon),
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        field.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        field.title,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconByName(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'business':
        return Icons.business;
      case 'medical':
        return Icons.local_hospital;
      case 'computer':
        return Icons.computer;
      case 'car':
        return Icons.directions_car;
      default:
        return Icons.help_outline;
    }
  }
}
