import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/users/Test_page.dart';

class DetailedCoursePage extends StatelessWidget {
  final String courseId;
  final String title;
  final String content;
  final String difficulty;

  const DetailedCoursePage({
    super.key,
    required this.courseId,
    required this.title,
    required this.content,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ColorConstants.primaryColor,
        title: Text(
          title,
          style: TextStyles.h6.copyWith(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double textSize = constraints.maxWidth > 600 ? 18 : 16;
          double padding = constraints.maxWidth > 600 ? 24.0 : 16.0;
          double maxWidth = constraints.maxWidth > 600 ? 600 : double.infinity;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: SizedBox(
                width: maxWidth,
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$title\n\n",
                        style: TextStyles.h5.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: textSize + 2,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: difficulty,
                        style: TextStyle(
                          fontSize: textSize,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: content,
                        style: TextStyle(
                          fontSize: textSize,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        icon: const Icon(Icons.quiz),
        label: const Text("Take Test"),
        onPressed: () {
          print(
              "🚀 Navigating to QuizScreen with: Difficulty: $difficulty, Course ID: $courseId");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                courseId: courseId,
                difficulty: difficulty,
              ),
            ),
          );
        },
      ),
    );
  }
}
