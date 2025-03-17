import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/view/users/edit_profile_page.dart';
import 'package:flutter_application_1/view/users/helps_and_support.dart';
import 'package:flutter_application_1/view/users/language_Selection_page.dart';
import 'package:flutter_application_1/view/users/refer_and_earn.dart';
import 'package:flutter_application_1/view/users/terms_policy.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;

  Future<Map<String, dynamic>?> _fetchUserData(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_roles')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      print("Document fetched via query: ${doc.data()}");
      return doc.data() as Map<String, dynamic>?;
    } else {
      print("No document found in user_roles with email: $email");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? "unknown@example.com";
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _fetchUserData(userEmail),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text("User data not found."),
                );
              }

              Map<String, dynamic> userData = snapshot.data!;
              String name = userData['user_name'] ?? 'No Name';
              String email = userData['email'] ?? 'No Email';
              String phone = userData['phone'] ?? 'No Phone';
              String profileImage = userData['profileImage'] ?? '';

              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : const AssetImage(
                                  '/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/profile.jpg')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                phone,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                  // dob: '',
                                  name: userData['user_name'],
                                  email: userEmail,
                                  // mobile: userData['mobile'],
                                  profileImage: profileImage),
                            ));
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReferAndEarn(),
                        ));
                  },
                ),
                settingsItem(
                  icon: Icons.help,
                  title: "Help & Support",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpsAndSupport(),
                        ));
                  },
                ),
                settingsItem(
                  icon: Icons.description,
                  title: "Terms & Conditions",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsPolicy(),
                        ));
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
