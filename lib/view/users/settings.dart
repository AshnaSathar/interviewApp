import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/users/language_Selection_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(
                      'assets/profile_placeholder.png'), // Replace with actual image
                ),
                const SizedBox(width: 16),
                // Name & Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ashna Sathar", // Replace with actual name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "+91 8848687997", // Replace with actual number
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.verified,
                              color: Colors.blue, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to Edit Profile Page
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Settings List
          Expanded(
            child: ListView(
              children: [
                settingsItem(
                  icon: Icons.language,
                  title: "Language Selection",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageSelectionPage(),
                        ));
                    // Navigate to Language Selection
                  },
                ),
                settingsItem(
                  icon: Icons.notifications,
                  title: "Push Notifications",
                  trailing: Switch(
                    value: pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        pushNotifications = value;
                      });
                    },
                  ),
                ),
                settingsItem(
                  icon: Icons.lock,
                  title: "Privacy Settings",
                  onTap: () {
                    // Navigate to Privacy Settings
                  },
                ),
                settingsItem(
                  icon: Icons.card_giftcard,
                  title: "Refer & Earn",
                  onTap: () {
                    // Navigate to Refer & Earn
                  },
                ),
                settingsItem(
                  icon: Icons.help,
                  title: "Help & Support",
                  onTap: () {
                    // Navigate to Help & Support
                  },
                ),
                settingsItem(
                  icon: Icons.description,
                  title: "Terms & Conditions",
                  onTap: () {
                    // Navigate to Terms & Conditions
                  },
                ),

                const SizedBox(height: 20),

                // Logout Button
                ListTile(
                  tileColor: Colors.white,
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Handle Logout
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget settingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
