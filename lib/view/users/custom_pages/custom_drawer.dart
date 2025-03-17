import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/users/feedback_page.dart';
import 'package:flutter_application_1/view/users/settings.dart';
import 'package:flutter_application_1/view/users/vacancy_list_page.dart';
import 'package:flutter_application_1/view/users/video_list_page.dart';
import 'package:flutter_application_1/view/users/view_application_page.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Stream<Map<String, dynamic>?> _fetchUserData(String email) {
    return FirebaseFirestore.instance
        .collection('user_roles')
        .where('email', isEqualTo: email)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? "unknown@example.com";

    return Drawer(
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: _fetchUserData(userEmail),
        builder: (context, snapshot) {
          String displayName = "User Name";

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            displayName = snapshot.data!['user_name'] ?? displayName;
          }

          return Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  displayName,
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.black),
                title:
                    const Text("Home", style: TextStyle(color: Colors.black)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.work, color: Colors.black),
                title: const Text("Vacancy",
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VacancyList()));
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.video_collection, color: Colors.black),
                title:
                    const Text("Videos", style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VideoListPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.subscriptions, color: Colors.black),
                title: const Text("Subscription",
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment, color: Colors.black),
                title: const Text("View Application",
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewMyApplications(candidateEmail: userEmail),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text("Settings",
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title:
                    const Text("Logout", style: TextStyle(color: Colors.black)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  context.go('/login'); // Redirect to login using go_router
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
