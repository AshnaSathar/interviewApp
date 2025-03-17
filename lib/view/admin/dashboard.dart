import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/view/admin/feedback_Admin.dart';
import 'package:flutter_application_1/view/admin/fields.dart';
import 'package:flutter_application_1/view/admin/jobsAdmin.dart';
import 'package:flutter_application_1/view/admin/questions.dart';
import 'package:flutter_application_1/view/admin/users.dart';
import 'package:flutter_application_1/view/admin/vaccancy.dart';
import 'package:flutter_application_1/view/admin/video_management.dart';
import 'package:flutter_application_1/view/users_pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Users", "icon": Icons.person, "page": UsersPage()},
    {"title": "Fields", "icon": Icons.category, "page": FieldsPage()},
    {"title": "Jobs", "icon": Icons.work, "page": JobsPageAdmin()},
    {
      "title": "Questions",
      "icon": Icons.question_answer,
      "page": QuestionsPage()
    },
    {"title": "Vacancy", "icon": Icons.assignment, "page": VacancyPage()},
    {"title": "Video", "icon": Icons.video_library, "page": VideoManagement()},
    {"title": "Feedbacks", "icon": Icons.feedback, "page": ManageFeedback()},
  ];

  final List<List<Color>> gradientColors = [
    [const Color(0xFF63B9FF), const Color(0xFF89B2F8), const Color(0xFFD5E3FB)],
    [Colors.green, const Color(0xFFB8EC81), Colors.lightGreen],
    [Colors.red, Colors.redAccent],
    [Colors.orange, Colors.deepOrange],
    [Colors.purple, Colors.deepPurple],
    [Colors.teal, Colors.tealAccent],
    [Colors.pink, Colors.pinkAccent],
  ];

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.go('/login');
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard",
            style: TextStyles.h5.copyWith(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Admin"),
              accountEmail: Text("Admin@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            Expanded(
              child: ListView(
                children: menuItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return ListTile(
                    leading: Icon(item["icon"]),
                    title: Text(item["title"]),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () => navigateToPage(context, item["page"]),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLargeScreen ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            var item = menuItems[index];
            var colors = gradientColors[index % gradientColors.length];

            return GestureDetector(
              onTap: () => navigateToPage(context, item["page"]),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item["icon"], size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      item["title"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
