import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/users/full_category_page.dart';
import 'package:flutter_application_1/view/users/jobs.dart';
import 'package:go_router/go_router.dart';

class CategorySlide extends StatefulWidget {
  const CategorySlide({super.key});

  @override
  State<CategorySlide> createState() => _CategorySlideState();
}

class _CategorySlideState extends State<CategorySlide> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Fields').get();
    final fetchedCategories = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "icon": data['icon'] ?? 'person',
        "title": data['title'] ?? '',
      };
    }).toList();

    setState(() {
      categories = fetchedCategories;
    });
  }

  IconData _getIconByName(String iconName) {
    const iconMap = {
      "person": Icons.person,
      "computer": Icons.computer,
      "medical_information": Icons.medical_information,
      "engineering": Icons.engineering,
      "business": Icons.business,
      "cast_for_education": Icons.cast_for_education,
      "gavel": Icons.gavel,
      "account_balance": Icons.account_balance,
      "movie": Icons.movie,
      "science": Icons.science,
      "travel_explore": Icons.travel_explore,
      "sports_soccer": Icons.sports_soccer,
    };

    return iconMap[iconName] ?? Icons.person;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4, // Soft blur
              spreadRadius: 1, // Slight spread
              offset: Offset(0, 2), // Slight downward offset
            ),
          ],
          color: Colors.white,
        ),
        height: MediaQuery.sizeOf(context).height * .18,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Category",
                    style: TextStyles.h6,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullCategoryPage(),
                        ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      "See all",
                      style: TextStyle(color: ColorConstants.primaryColor),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final iconName = category["icon"] as String;
                  final iconData = _getIconByName(iconName);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobsListPage(fieldId: category['id']),
                                  ));
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                iconData,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category["title"],
                          textAlign: TextAlign.center,
                          style: TextStyles.normalText.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
