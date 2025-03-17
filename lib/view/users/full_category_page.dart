import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/controller/question_controller/job_fields_controller.dart';
import 'package:flutter_application_1/view/users/jobs.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('All Categories'),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
          double boxSize = constraints.maxWidth / crossAxisCount - 20;

          return jobFieldController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: jobFieldController.fields.length,
                  itemBuilder: (context, index) {
                    final field = jobFieldController.fields[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JobsListPage(fieldId: field.id),
                          ),
                        );
                      },
                      child: Container(
                        width: boxSize,
                        height: boxSize,
                        decoration: BoxDecoration(
                          color: ColorConstants.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconByName(field.icon),
                              size: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              field.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              field.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
