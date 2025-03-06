import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
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
        "icon":
            data['icon'] ?? 'person', // Default to 'person' if icon not present
        "title": data['title'] ?? ''
      };
    }).toList();

    setState(() {
      categories = fetchedCategories;
    });
  }

  // Helper function to convert icon string to actual Flutter IconData
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

    // Return matching icon or fallback to person icon
    return iconMap[iconName] ?? Icons.person;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
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
                  context.go('/categories');
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length > 4 ? 5 : categories.length,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return GestureDetector(
                    onTap: () {
                      context.go('/category');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "See All",
                          style: TextStyles.normalText.copyWith(
                            fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                  );
                }

                final category = categories[index];
                final iconName = category["icon"] as String;
                final iconData = _getIconByName(iconName);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
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
                            color: Colors.white,
                            size: 30,
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
    );
  }
}
