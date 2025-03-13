import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/view/users/settings.dart';
import 'package:flutter_application_1/view/users/vacancy_list_page.dart';
import 'package:flutter_application_1/view/users/video_list_page.dart';
import 'package:flutter_application_1/view/users/view_application_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user from FirebaseAuth.
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? "unknown@example.com";
    final userName =
        user?.displayName ?? "User Name"; // Or fallback to a default.

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(color: Colors.black87),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey.shade700),
            ),
            decoration: const BoxDecoration(color: ColorConstants.primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: ColorConstants.primaryColor),
            title: const Text("Homes"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: ColorConstants.primaryColor),
            title: const Text("Vacancy"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VacancyList(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: ColorConstants.primaryColor),
            title: const Text("Videos"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoListPage(),
                  ));
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.settings, color: ColorConstants.primaryColor),
            title: const Text("View Application"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewMyApplications(candidateEmail: userEmail),
                  ));
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.settings, color: ColorConstants.primaryColor),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ));
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.logout, color: ColorConstants.primaryColor),
            title: const Text("Logout"),
            onTap: () {
              // Handle logout logic, e.g. FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
