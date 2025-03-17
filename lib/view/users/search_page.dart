import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/users/question_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
    searchController.addListener(filterJobs);
  }

  Future<void> fetchJobs() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('jobs').get();

      final List<Map<String, dynamic>> fetchedJobs = snapshot.docs.map((doc) {
        return {
          'name': doc['name'] ?? '',
          'jobId': doc.id,
        };
      }).toList();

      setState(() {
        jobs = fetchedJobs;
        filteredJobs = jobs;
      });
    } catch (e) {
      print("Error fetching jobs: $e");
    }
  }

  void filterJobs() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredJobs = jobs
          .where((job) => job['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Search Jobs",
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: ColorConstants.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Enter job name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return ListTile(
                        title: Text(job['name']),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionPage(jobId: job['jobId']),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
