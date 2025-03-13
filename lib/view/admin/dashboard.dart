import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/admin/fields.dart';
import 'package:flutter_application_1/view/admin/jobsAdmin.dart';
import 'package:flutter_application_1/view/admin/questions.dart';
import 'package:flutter_application_1/view/admin/users.dart';
import 'package:flutter_application_1/view/admin/vaccancy.dart';
import 'package:flutter_application_1/view/admin/video_management.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Admin"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    Icon(Icons.person, size: 40, color: Colors.grey.shade700),
              ),
              accountEmail: Text("Admin@gmail.com"),
            ),
            ListTile(
              onTap: () => navigateToPage(context, UsersPage()),
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              title: Text("Users"),
            ),
            ListTile(
              onTap: () => navigateToPage(context, FieldsPage()),
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              title: Text("Fields"),
            ),
            ListTile(
              onTap: () => navigateToPage(context, JobsPageAdmin()),
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              title: Text("Jobs"),
            ),
            ListTile(
              onTap: () => navigateToPage(context, QuestionsPage()),
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              title: Text("Questions"),
            ),
            ListTile(
              onTap: () => navigateToPage(context, VacancyPage()),
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              title: Text("Vaccancy"),
            ),
            ListTile(
              onTap: () => navigateToPage(context, VideoManagement()),
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
              title: Text("Video"),
            ),
          ],
        ),
      ),
    );
  }
}
