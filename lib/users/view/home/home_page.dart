import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/users/view/category_slide.dart';
import 'package:flutter_application_1/users/view/custom_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> jobs = [
    {
      "title": "Software Engineer",
      "image":
          "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/swEng1.jpeg"
    },
    {
      "title": "Data Analyst",
      "image":
          "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/data_analyst.jpeg"
    },
    {
      "title": "UI/UX Designer",
      "image":
          "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/ui_ux_dev.webp"
    },
    {
      "title": "Project Manager",
      "image":
          "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/project_manager.jpeg"
    },
    {
      "title": "Marketing Specialist",
      "image":
          "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/marketting_specialist.jpeg"
    },
    {
      "title": "HR Manager",
      "image":
          "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/hr_manager.jpeg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ColorConstants.primaryColor,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            height: height * .2,
            width: width,
            child: Lottie.asset("assets/images/Animation - 1739080900242.json"),
          ),
          CategorySlide(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  "Main Jobs",
                  style: TextStyles.h5,
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    //
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: jobs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      //
                      context.go('/questions');
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            Image.asset(
                              jobs[index]["image"]!,
                              height: height * .2,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              jobs[index]["title"]!,
                              style: TextStyles.normalText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
