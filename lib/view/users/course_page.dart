import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/course_provider.dart';
import 'package:flutter_application_1/model/course_model.dart';
import 'package:flutter_application_1/view/users/detailed_course_page.dart';
import 'package:provider/provider.dart';

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

    print(
        "🚀 Navigating to DetailedCoursePage with: Difficulty: $safeDifficulty, Course ID: ${course.id}");

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
              return ListTile(
                title: Text(
                  course.title,
                  style: TextStyles.normalText.copyWith(fontSize: 16),
                ),
                subtitle: Text(course.difficulty.toUpperCase()),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.grey),
                onTap: () => _navigateToDetail(context, course),
              );
            },
          );
        },
      ),
    );
  }
}
