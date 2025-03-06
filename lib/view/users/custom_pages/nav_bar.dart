import 'package:flutter/material.dart';

import 'package:flutter_application_1/view/users/custom_pages/bottomNavBar.dart';
import 'package:flutter_application_1/view/users/favourite_page.dart';
import 'package:flutter_application_1/view/users/home_page.dart';
import 'package:flutter_application_1/view/users/profile_page.dart';

class NavPage extends StatelessWidget {
  final int index;
  const NavPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(),
      FavouritePage(),
      ProfilePage(),
    ];

    return Scaffold(
      body:
          pages[index], // Just load the page based on the initial index passed
      bottomNavigationBar: BottomNavBar(
        onTabSelected: (p0) {},

        currentIndex: index, // This can just show which tab is active
      ),
    );
  }
}
