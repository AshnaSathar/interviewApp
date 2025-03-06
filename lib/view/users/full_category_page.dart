import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/question_controller/question_controller.dart';
import 'package:flutter_application_1/view/users/jobs.dart';
import 'package:go_router/go_router.dart';
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
      // Provider.of<QuestionController>(context, listen: false).fetchFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobFieldController = Provider.of<QuestionController>(context);
    final categories = jobFieldController.fields;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.go('/nav');
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: jobFieldController.isLoadingFields
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to Job List Page and pass the selected category
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         JobPage(selectedCategory: categories[index]),
                    //   ),
                    // );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        // Placeholder for icon
                      ),
                      const SizedBox(height: 5),
                      Text(
                        categories[index],
                        textAlign: TextAlign.center,
                        style: TextStyles.h6,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
