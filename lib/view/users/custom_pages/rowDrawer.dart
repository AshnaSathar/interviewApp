import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/users/feedback_page.dart';
import 'package:flutter_application_1/view/users/vacancy_list_page.dart';
import 'package:flutter_application_1/view/users/video_list_page.dart';
import 'package:flutter_application_1/view/users/view_application_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerRow extends StatelessWidget {
  const DrawerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using FirebaseAuth.currentUser to pass candidateEmail to ViewMyApplications.
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Vacancy container
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VacancyList()),
              );
            },
            child: Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.work, color: Colors.black),
                  SizedBox(height: 4),
                  Text(
                    "Vacancy",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Videos container
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VideoListPage()),
              );
            },
            child: Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.video_collection, color: Colors.black),
                  SizedBox(height: 4),
                  Text(
                    "Videos",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Subscription container
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );
            },
            child: Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.subscriptions, color: Colors.black),
                  SizedBox(height: 4),
                  Text(
                    "Subscription",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // View Application container
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewMyApplications(candidateEmail: userEmail),
                ),
              );
            },
            child: Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assignment, color: Colors.black),
                  SizedBox(height: 4),
                  Text(
                    "View App",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
