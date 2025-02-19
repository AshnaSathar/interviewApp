import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected; // Callback to update index in NavPage

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      backgroundColor: Colors.white,
      color: ColorConstants.primaryColor,
      activeColor: Colors.blue,
      initialActiveIndex: currentIndex,
      items: const [
        TabItem(
          icon: Icons.home,
        ),
        TabItem(
          icon: Icons.add,
        ),
        TabItem(
          icon: Icons.person,
        ),
      ],
      onTap: (int index) {
        onTabSelected(index);
      },
    );
  }
}
