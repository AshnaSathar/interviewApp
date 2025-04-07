import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/course_provider.dart';
import 'package:flutter_application_1/model/course_model.dart';
import 'package:provider/provider.dart';

class AddContents extends StatefulWidget {
  const AddContents({super.key});

  @override
  State<AddContents> createState() => _AddContentsState();
}

class _AddContentsState extends State<AddContents> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDifficulty = 'easy';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final newCourse = CourseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        difficulty: _selectedDifficulty,
      );

      Provider.of<CourseProvider>(context, listen: false)
          .addCourse(_selectedDifficulty, newCourse)
          .then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add course: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Course"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Difficulty"),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                items: ['easy', 'medium', 'hard']
                    .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Course Title"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: "Course Content"),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? "Please enter content" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCourse,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
