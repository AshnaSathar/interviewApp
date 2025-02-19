import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:go_router/go_router.dart';

class CategorySlide extends StatefulWidget {
  const CategorySlide({super.key});

  @override
  State<CategorySlide> createState() => _CategorySlideState();
}

class _CategorySlideState extends State<CategorySlide> {
  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.medical_information, "title": "Medical"},
    {"icon": Icons.computer, "title": "IT"},
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
              Spacer(),
              InkWell(
                onTap: () {
                  //
                  context.go('/categories');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
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
              itemCount: 5,
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
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(categories[index]["icon"],
                              color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(categories[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyles.normalText
                              .copyWith(fontWeight: FontWeight.w400)),
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
