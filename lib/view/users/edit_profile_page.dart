import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String designation;
  final String email;
  final String dob;
  final String mobile;
  final String profileImage;

  const EditProfilePage(
      {super.key,
      required this.name,
      required this.designation,
      required this.email,
      required this.dob,
      required this.mobile,
      required this.profileImage});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController designationController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController mobileController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    designationController = TextEditingController(text: widget.designation);
    emailController = TextEditingController(text: widget.email);
    dobController = TextEditingController(text: widget.dob);
    mobileController = TextEditingController(text: widget.mobile);
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    emailController.dispose();
    dobController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void saveProfile() {
    Navigator.pop(context, {
      "name": nameController.text,
      "designation": designationController.text,
      "email": emailController.text,
      "dob": dobController.text,
      "mobile": mobileController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Name", nameController),
              buildTextField("Designation", designationController),
              buildTextField("Email", emailController),
              buildTextField("Date of Birth", dobController),
              buildTextField("Mobile Number", mobileController),

              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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
