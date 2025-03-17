import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';
import 'package:flutter_application_1/model/application_model.dart';
import 'package:flutter_application_1/controller/application_controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyForPostPage extends StatefulWidget {
  final VacancyModel vacancy;

  const ApplyForPostPage({Key? key, required this.vacancy}) : super(key: key);

  @override
  _ApplyForPostPageState createState() => _ApplyForPostPageState();
}

class _ApplyForPostPageState extends State<ApplyForPostPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String candidatePhone = '';
  File? resumeFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('user_roles')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          print(data);
          setState(() {
            nameController.text = data['user_name'] ?? '';
            emailController.text = data['email'] ?? '';
          });
        } else {
          print("No user_roles document found for ${user.email}");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        resumeFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _confirmAndSubmitApplication() async {
    bool confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Submission"),
            content: const Text(
                "Once submitted, your application cannot be edited. Do you want to submit?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Submit",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      if (_formKey.currentState!.validate() && resumeFile != null) {
        final application = ApplicationModel(
          vacancyId: widget.vacancy.id,
          candidateName: nameController.text,
          candidateEmail: emailController.text,
          candidatePhone: candidatePhone,
          resumePath: resumeFile!.path,
        );

        try {
          await Provider.of<ApplicationController>(context, listen: false)
              .submitApplication(application);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Application submitted successfully!')),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting application: $e')),
          );
        }
      } else {
        if (resumeFile == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please upload your resume.')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for ${widget.vacancy.jobPosition}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Vacancy: ${widget.vacancy.jobPosition}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Your Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Your Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length != 10)
                    return 'Enter a 10-digit phone number';
                  return null;
                },
                onChanged: (val) => candidatePhone = val,
              ),
              const SizedBox(height: 16),
              const Text(
                "Upload Resume:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickResumeFile,
                icon: const Icon(Icons.upload_file),
                label: const Text("Choose File"),
              ),
              resumeFile != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Selected File: ${resumeFile!.path.split('/').last}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _confirmAndSubmitApplication,
                child: const Text("Submit Application"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
