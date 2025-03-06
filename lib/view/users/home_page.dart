import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/users/category_slide.dart';
import 'package:flutter_application_1/view/users/custom_pages/all_jobs.dart';
import 'package:flutter_application_1/view/users/custom_pages/custom_drawer.dart';
import 'package:flutter_application_1/view/users/question_page.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> jobs = [];

  // Image list - ensure these paths are correct within your project (assets folder)
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
          'image': images[index % images.length], // Assign images cyclically
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorConstants.primaryColor),
        backgroundColor: Colors.white,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              )
            : const Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
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
          // Stack(
          //   children: [
          //     Container(
          //       color: Colors.white,
          //       height: height * .3,
          //       width: width,
          //       child: Image.asset(
          //         "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/mot.jpg",
          //         fit: BoxFit.fill,
          //       ),
          //     ),
          // Text(
          //   "Practice Questions to Boost Your Confidence",
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
          //   ],
          // )
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "Practice Questions to Boost Your Confidence",
          //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //   ),
          // ),
          // Container(
          //   color: Colors.white,
          //   height: height * .2,
          //   width: width,
          //   child: Lottie.asset("assets/images/Animation - 1739080900242.json"),
          // ),
          // ,
          const CategorySlide(),
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
                      MaterialPageRoute(builder: (context) => AllJobsPage()),
                    );
                  },
                  child: const Text("See all",
                      style: TextStyle(color: ColorConstants.primaryColor)),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: jobs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: jobs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .8,
                      ),
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuestionPage(jobId: job['jobId'])));
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
                                  Expanded(
                                    child: Image.asset(
                                      job['image'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    job['name'],
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
