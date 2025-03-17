import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/users/home_page.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  // final String dob;
  final String profileImage;
  // final List<String> userRoles; // Added user roles

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    // required this.dob,
    required this.profileImage,
    // required this.userRoles, // Initialize user roles
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  // late TextEditingController dobController;
  List<String> updatedUserRoles = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    // dobController = TextEditingController(text: widget.dob);
    // updatedUserRoles = List.from(widget.userRoles); // Copy user roles
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    // dobController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('user_roles');

    // Assuming user email is unique, fetch the correct document
    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: emailController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference userDoc = querySnapshot.docs.first.reference;
      await userDoc.update({
        'email': emailController.text,
        'user_name': nameController.text,
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
      // Navigator.pop(context, {
      //   "name": nameController.text,
      //   "email": emailController.text,
      // });
    } else {
      print("User not found!");
    }
  }

  Future<void> updateUserRoles(List<String> roles) async {
    // TODO: Replace with API call or database update logic
    print("Updated User Roles: $roles");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Name", nameController),
              buildTextField("Email", emailController),

              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
