import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:go_router/go_router.dart';

class FullCategoryPage extends StatelessWidget {
  const FullCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.medical_information, "title": "Medical"},
      {"icon": Icons.computer, "title": "Information Technology"},
      {"icon": Icons.engineering, "title": "Engineering"},
      {"icon": Icons.business, "title": "Business & Finance"},
      {"icon": Icons.cast_for_education, "title": "Education & Teaching"},
      {"icon": Icons.gavel, "title": "Law & Legal Services"},
      {
        "icon": Icons.account_balance,
        "title": "Government & Public Administration"
      },
      {"icon": Icons.movie, "title": "Arts, Media & Entertainment"},
      {"icon": Icons.science, "title": "Science & Research"},
      {"icon": Icons.travel_explore, "title": "Hospitality & Tourism"},
      {"icon": Icons.sports_soccer, "title": "Sports & Fitness"},
    ];
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.go('/nav');
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(categories[index]["icon"],
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 5),
              Text(
                categories[index]["title"]!,
                textAlign: TextAlign.center,
                style: TextStyles.h6,
              ),
            ],
          );
        },
      ),
    );
  }
}
