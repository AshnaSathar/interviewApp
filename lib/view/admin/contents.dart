import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/course_provider.dart';
import 'package:flutter_application_1/model/course_model.dart';
import 'package:flutter_application_1/view/admin/add_test_page.dart';
import 'package:provider/provider.dart';
import 'add_contents.dart';

class ContentAdminPage extends StatefulWidget {
  const ContentAdminPage({super.key});

  @override
  State<ContentAdminPage> createState() => _ContentAdminPageState();
}

class _ContentAdminPageState extends State<ContentAdminPage> {
  @override
  void initState() {
    super.initState();
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    courseProvider.fetchCourses('easy');
    courseProvider.fetchCourses('medium');
    courseProvider.fetchCourses('hard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: Text(
          "Manage Courses",
          style: TextStyles.normalText.copyWith(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Consumer<CourseProvider>(
            builder: (context, courseProvider, child) {
              List<CourseModel> allCourses = [
                ...courseProvider.easyCourses,
                ...courseProvider.mediumCourses,
                ...courseProvider.hardCourses
              ];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: constraints.maxWidth > 600
                    ? _buildGridView(allCourses)
                    : _buildListView(allCourses),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContents()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(List<CourseModel> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        CourseModel course = courses[index];
        return _buildCourseTile(course);
      },
    );
  }

  Widget _buildGridView(List<CourseModel> courses) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _buildCourseTile(courses[index]);
      },
    );
  }

  Widget _buildCourseTile(CourseModel course) {
    final provider = Provider.of<CourseProvider>(context, listen: false);

    return FutureBuilder<bool>(
      future: provider.hasTest(_getDifficulty(course).toLowerCase(), course.id),
      builder: (context, snapshot) {
        bool hasTest = snapshot.data ?? false;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(course.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Difficulty: ${_getDifficulty(course)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                hasTest
                    ? const Text("Test Added",
                        style: TextStyle(color: Colors.green))
                    : InkWell(
                        onTap: () {
                          _navigateToAddTest(course);
                        },
                        child: Icon(Icons.add)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCourse(course),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToAddTest(CourseModel course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTestPage(
            course: course, difficulty: _getDifficulty(course).toLowerCase()),
      ),
    );
  }

  void _deleteCourse(CourseModel course) {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    String difficulty = _getDifficulty(course);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Course"),
        content: Text("Are you sure you want to delete '${course.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCourse(difficulty.toLowerCase(), course.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getDifficulty(CourseModel course) {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    return provider.easyCourses.contains(course)
        ? "Easy"
        : provider.mediumCourses.contains(course)
            ? "Medium"
            : "Hard";
  }
}
