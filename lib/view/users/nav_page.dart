import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/users/custom_pages/bottomNavBar.dart';
import 'package:flutter_application_1/view/users/home_page.dart';
import 'package:flutter_application_1/view/users/profile_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    // AddQuestions(),
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
