import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/view/users/settings.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Ashna Sathar",
              style: TextStyle(color: Colors.black87),
            ), // Replace with actual user data
            accountEmail: const Text("ashnasathar@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey.shade700),
            ),
            decoration: const BoxDecoration(color: ColorConstants.primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: ColorConstants.primaryColor),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.settings, color: ColorConstants.primaryColor),
            title: const Text(
              "Settings",
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: ColorConstants.primaryColor,
            ),
            title: const Text("Logout"),
            onTap: () {
              // Handle logout logic here
            },
          ),
        ],
      ),
    );
  }
}
