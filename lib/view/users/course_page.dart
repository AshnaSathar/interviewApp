import 'package:flutter/material.dart';
// import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/course_controller.dart';
import 'package:flutter_application_1/controller/course_provider.dart';
import 'package:flutter_application_1/model/course_model.dart';
import 'package:flutter_application_1/view/users/detailed_course_page.dart';
import 'package:flutter_application_1/view/users/payment.dart';
import 'package:flutter_application_1/view/users_pages/add_card.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    super.initState();
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    courseProvider.fetchCourses('easy');
    courseProvider.fetchCourses('medium');
    courseProvider.fetchCourses('hard');
  }

  void _navigateToDetail(BuildContext context, CourseModel course) {
    final String safeDifficulty =
        course.difficulty.isNotEmpty ? course.difficulty : 'easy';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedCoursePage(
          courseId: course.id,
          title: course.title,
          content: course.content,
          difficulty: safeDifficulty,
        ),
      ),
    );
  }

  Future<void> _showCardSelectionBottomSheet() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in.")),
      );
      return;
    }
    final email = currentUser.email!;

    final cardDoc = await FirebaseFirestore.instance
        .collection('user_cards')
        .doc(email)
        .get();
    if (!cardDoc.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddCardPage()),
      );
      return;
    }

    final cardData = cardDoc.data()!;
    int selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateSheet) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Select Card",
                    style: TextStyles.normalText
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      // color: const Color.fromARGB(255, 219, 219, 219),
                      child: ListView(
                        children: [
                          RadioListTile<int>(
                            title: Text(
                              "Card: **** **** **** ${cardData['cardNumber'].toString().substring(cardData['cardNumber'].toString().length - 4)}",
                            ),
                            value: 0,
                            groupValue: selectedIndex,
                            onChanged: (int? value) {
                              setStateSheet(() {
                                selectedIndex = value ?? 0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Pay",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleCourseTap(CourseModel course, String diff) async {
    Provider.of<MyCourseController>(context, listen: false).selectedCourse =
        course;
    print("Selected course is");
    print(Provider.of<MyCourseController>(context, listen: false)
        .selectedCourse
        .id);
    if (diff == "ADVANCE") {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in.")),
        );
        return;
      }
      print("checking");
      print(course.id);
      final subscriptionSnap = await FirebaseFirestore.instance
          .collection('my_course')
          .where('courseId', isEqualTo: course.id)
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (subscriptionSnap.docs.isNotEmpty) {
        _navigateToDetail(context, course);
      } else {
        _showCardSelectionBottomSheet();
      }
    } else {
      _navigateToDetail(context, course);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Courses",
          style: TextStyles.normalText.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          List<CourseModel> allCourses = [
            ...courseProvider.easyCourses,
            ...courseProvider.mediumCourses,
            ...courseProvider.hardCourses,
          ];
          return ListView.builder(
            itemCount: allCourses.length,
            itemBuilder: (context, index) {
              final course = allCourses[index];

              String diff;
              if (course.difficulty.toLowerCase() == "easy") {
                diff = "BEGIN";
              } else if (course.difficulty.toLowerCase() == "medium") {
                diff = "INTERMEDIATE";
              } else {
                diff = "ADVANCE";
              }

              return ListTile(
                title: Text(
                  course.title,
                  style: TextStyles.normalText.copyWith(fontSize: 16),
                ),
                subtitle: Text(diff),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () async {
                  await _handleCourseTap(course, diff);
                },
              );
            },
          );
        },
      ),
    );
  }
}
