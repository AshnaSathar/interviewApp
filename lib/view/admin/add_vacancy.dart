import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/vaccancy_controller.dart';
import 'package:flutter_application_1/model/vaccancy_model.dart';
import 'package:provider/provider.dart';

class AddVacancyPage extends StatefulWidget {
  final VacancyModel? vacancy;

  AddVacancyPage({this.vacancy});

  @override
  _AddVacancyPageState createState() => _AddVacancyPageState();
}

class _AddVacancyPageState extends State<AddVacancyPage> {
  final _formKey = GlobalKey<FormState>();

  // For adding a new vacancy, these fields must be filled.
  // When updating, they are read-only.
  final Map<String, dynamic> vacancyData = {
    'jobPosition': '',
    'companyName': '',
    'location': '',
    'companyAddress': '',
    'phoneNumber': '',
    'email': '',
    'salary': null, // expects a number
    'place': '',
    'description': '',
    'jobType': '', // dropdown field
    'preferredSkills': <String>[],
    'languagePreferred': <String>[],
    'experience': null, // number (years)
    'ageFrom': null, // number
    'ageTo': null, // number
  };

  TextEditingController _skillController = TextEditingController();
  TextEditingController _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vacancy != null) {
      vacancyData.addAll(widget.vacancy!.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    final vacancyController =
        Provider.of<VacancyController>(context, listen: false);
    final bool isUpdate = widget.vacancy != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Update Vacancy' : 'Add Vacancy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          // Validate on user interaction.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              // Required fields when adding; read-only when updating.
              _buildTextField('Job Position', 'jobPosition',
                  required: true, readOnly: isUpdate),
              _buildTextField('Company Name', 'companyName',
                  required: true, readOnly: isUpdate),
              _buildTextField('Location', 'location',
                  required: true, readOnly: isUpdate),
              _buildTextField('Company Address', 'companyAddress',
                  required: true, readOnly: isUpdate),
              _buildTextField('Phone Number', 'phoneNumber',
                  required: true,
                  readOnly: isUpdate,
                  keyboardType: TextInputType.number),
              _buildTextField('Email', 'email',
                  required: true,
                  readOnly: isUpdate,
                  keyboardType: TextInputType.emailAddress),
              // Salary now uses a number field.
              _buildNumberField('Salary', 'salary'),
              _buildTextField('Place', 'place'),
              _buildTextField('Description', 'description', required: true),
              _buildDropdownField('Job Type', 'jobType'),
              // Experience, Age From, Age To are number fields.
              _buildNumberField('Experience (years)', 'experience'),
              _buildNumberField('Age From', 'ageFrom'),
              _buildNumberField('Age To', 'ageTo'),
              _buildTagInputField(
                  'Preferred Skills', _skillController, 'preferredSkills'),
              _buildTagInputField('Language Preferred', _languageController,
                  'languagePreferred'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // For debugging, print the vacancyData map.
                      print("Submitting vacancyData: $vacancyData");
                      final newVacancy = VacancyModel.fromMap(
                        vacancyData,
                        id: widget.vacancy?.id ?? '',
                      );
                      if (isUpdate) {
                        await vacancyController.updateVacancy(
                            newVacancy.id, newVacancy);
                      } else {
                        await vacancyController.addVacancy(newVacancy);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      print("Error adding/updating vacancy: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text(isUpdate ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key,
      {bool required = false,
      bool readOnly = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: vacancyData[key]?.toString() ?? '',
        readOnly: readOnly,
        keyboardType: keyboardType,
        onChanged: (val) => vacancyData[key] = val,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) {
          if (required && (val == null || val.trim().isEmpty)) {
            return 'Required';
          }
          if (key == 'phoneNumber' && val != null && val.trim().isNotEmpty) {
            final numericRegex = RegExp(r'^\d{10}$');
            if (!numericRegex.hasMatch(val.trim())) {
              return 'Enter a valid 10-digit phone number';
            }
          }
          if (key == 'email' && val != null && val.trim().isNotEmpty) {
            if (!val.trim().endsWith('@gmail.com')) {
              return 'Email must be @gmail.com';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberField(String label, String key, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: vacancyData[key]?.toString() ?? '',
        keyboardType: TextInputType.number,
        onChanged: (val) {
          // Try to parse the number; if fails, set as null.
          vacancyData[key] = int.tryParse(val.trim()) ?? null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) {
          if (required && (val == null || val.trim().isEmpty)) {
            return 'Required';
          }
          if (val != null && val.trim().isNotEmpty) {
            if (int.tryParse(val.trim()) == null) {
              return 'Enter a valid number';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String key,
      {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: vacancyData[key] != '' ? vacancyData[key] : null,
        items: [
          DropdownMenuItem(value: "Online", child: Text("Online")),
          DropdownMenuItem(value: "Offline", child: Text("Offline")),
          DropdownMenuItem(value: "Remote", child: Text("Remote")),
        ],
        onChanged: (val) {
          setState(() {
            vacancyData[key] = val;
          });
        },
        validator: required
            ? (val) => val == null || val.isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _buildTagInputField(
      String label, TextEditingController controller, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: (vacancyData[key] as List<String>).map((item) {
              return Chip(
                label: Text(item),
                onDeleted: () {
                  setState(() {
                    (vacancyData[key] as List<String>).remove(item);
                  });
                },
              );
            }).toList(),
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Type and press Enter',
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  (vacancyData[key] as List<String>).add(val);
                  controller.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
