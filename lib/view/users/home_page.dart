import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/users/category_slide.dart';
import 'package:flutter_application_1/view/users/custom_pages/all_jobs.dart';
import 'package:flutter_application_1/view/users/custom_pages/custom_drawer.dart';
import 'package:flutter_application_1/view/users/custom_pages/rowDrawer.dart';
import 'package:flutter_application_1/view/users/question_page.dart';
import 'package:flutter_application_1/view/users/search_page.dart';
import 'package:flutter_application_1/view/users/vacancy_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> jobs = [];

  List<String> images = [
    "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/img1.jpg",
    "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/img2.jpg",
    "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/img3.jpg",
    "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/img4.jpg",
    "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/img5.jpg",
    "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/img6.jpg",
  ];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('jobs').get();

      final List<Map<String, dynamic>> fetchedJobs =
          snapshot.docs.asMap().entries.map((entry) {
        int index = entry.key;
        var doc = entry.value;

        return {
          'name': doc['name'] ?? '',
          'image': images[index % images.length],
          'jobId': doc.id,
        };
      }).toList();

      setState(() {
        jobs = fetchedJobs;
      });
    } catch (e) {
      print("Error fetching jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ));
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
          // title: isSearching
          //     ? TextField(
          //         controller: searchController,
          //         autofocus: true,
          //         style: const TextStyle(color: Colors.black),
          //         decoration: const InputDecoration(
          //           hintText: "Search",
          //           hintStyle: TextStyle(color: Colors.black),
          //           border: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.black),
          //           ),
          //         ),
          //       )
          //     : const Text(
          //         "",
          //         style: TextStyle(color: Colors.white),
          //       ),
          // actions: [
          //   IconButton(
          //     icon: Icon(isSearching ? Icons.close : Icons.search),
          //     onPressed: () {
          //       setState(() {
          //         // isSearching = !isSearching;
          //         if (!isSearching) {
          //           searchController.clear();
          //         }
          //       });
          //     },
          //   ),
          // ],
        ),
        drawer: const CustomDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: height * .2,
              width: width,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // On larger screens, limit width to 800 pixels.
                        final containerWidth = constraints.maxWidth > 800
                            ? 800.0
                            : constraints.maxWidth;
                        // Set height: 250 pixels for larger screens, or half of the width for smaller screens.
                        final containerHeight = constraints.maxWidth > 800
                            ? 250.0
                            : constraints.maxWidth * 0.5;
                        return Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VacancyList()),
                              );
                            },
                            child: Container(
                              width: containerWidth,
                              height: containerHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  '/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/vaccancy.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Row(
                  //   children: [DrawerRow()],
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CategorySlide()),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text("Main Jobs", style: TextStyles.h5),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllJobsPage()),
                      );
                    },
                    child: const Text("See all",
                        style: TextStyle(color: Colors.black)),
                  )
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  int crossAxisCount;
                  double childAspectRatio;

                  if (screenWidth >= 1200) {
                    crossAxisCount = 5;
                    childAspectRatio = 1.0;
                  } else if (screenWidth >= 900) {
                    crossAxisCount = 4;
                    childAspectRatio = 0.9;
                  } else if (screenWidth >= 600) {
                    crossAxisCount = 3;
                    childAspectRatio = 0.85;
                  } else {
                    crossAxisCount = 2;
                    childAspectRatio = 0.85;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: jobs.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            itemCount: jobs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuestionPage(
                                              jobId: job['jobId'])));
                                },
                                child: Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: double.infinity,
                                          child: Image.asset(
                                            job['image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            job['name'],
                                            style: TextStyles.normalText
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
