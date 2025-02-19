import 'package:flutter/material.dart';
import 'package:flutter_application_1/users/view/add_questions.dart';
import 'package:flutter_application_1/users/view/bottomNavBar.dart';
import 'package:flutter_application_1/users/view/home/home_page.dart';
import 'package:flutter_application_1/users/view/profile/profile_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    AddQuestions(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
