import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';
import 'package:flutter_application_1/model/application_model.dart';
import 'package:flutter_application_1/controller/application_controller.dart';
import 'package:provider/provider.dart';

class ApplyForPostPage extends StatefulWidget {
  final VacancyModel vacancy;

  const ApplyForPostPage({Key? key, required this.vacancy}) : super(key: key);

  @override
  _ApplyForPostPageState createState() => _ApplyForPostPageState();
}

class _ApplyForPostPageState extends State<ApplyForPostPage> {
  final _formKey = GlobalKey<FormState>();
  String candidateName = '';
  String candidateEmail = '';
  String candidatePhone = '';
  File? resumeFile;

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
    // Show confirmation dialog before submission.
    bool confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Submission"),
            content: Text(
                "Once submitted, your application cannot be edited. Do you want to submit?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Submit",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      if (_formKey.currentState!.validate() && resumeFile != null) {
        final application = ApplicationModel(
          vacancyId: widget.vacancy.id,
          candidateName: candidateName,
          candidateEmail: candidateEmail,
          candidatePhone: candidatePhone,
          resumePath: resumeFile!.path,
        );

        try {
          await Provider.of<ApplicationController>(context, listen: false)
              .submitApplication(application);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Application submitted successfully!')),
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
            SnackBar(content: Text('Please upload your resume.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for ${widget.vacancy.jobPosition}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Vacancy: ${widget.vacancy.jobPosition}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onChanged: (val) => candidateName = val,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Your Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
                onChanged: (val) => candidateEmail = val,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
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
              SizedBox(height: 16),
              Text(
                "Upload Resume:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickResumeFile,
                icon: Icon(Icons.upload_file),
                label: Text("Choose File"),
              ),
              resumeFile != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Selected File: ${resumeFile!.path.split('/').last}",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )
                  : Container(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _confirmAndSubmitApplication,
                child: Text("Submit Application"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
