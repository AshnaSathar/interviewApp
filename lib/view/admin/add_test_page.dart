import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/course_provider.dart';
import 'package:flutter_application_1/model/course_model.dart';
import 'package:provider/provider.dart';

class AddTestPage extends StatefulWidget {
  final CourseModel course;
  final String difficulty;

  const AddTestPage({
    super.key,
    required this.course,
    required this.difficulty,
  });

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  List<Map<String, dynamic>> questions = List.generate(
    10,
    (index) => {
      "question": TextEditingController(),
      "options": List.generate(4, (i) => TextEditingController()),
      "correctAnswer": "",
    },
  );

  void _saveTest() {
    bool hasEmptyFields = questions.any((q) {
      if (q["question"].text.trim().isEmpty) return true;
      if ((q["correctAnswer"] as String).trim().isEmpty) return true;
      List<TextEditingController> options =
          List<TextEditingController>.from(q["options"]);
      if (options.any((o) => o.text.trim().isEmpty)) return true;
      return false;
    });

    if (hasEmptyFields) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    Future.wait(questions.map((q) {
      return courseProvider.addTest(
        widget.course.id,
        widget.difficulty,
        q["question"].text,
        List<String>.from(q["options"].map((controller) => controller.text)),
        q["correctAnswer"],
      );
    })).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Test Added Successfully")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to add test: $error")));
    });
  }

  @override
  void dispose() {
    for (var q in questions) {
      q["question"].dispose();
      for (var opt in q["options"]) {
        opt.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Test for ${widget.course.title}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Question ${index + 1}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextField(
                          controller: questions[index]["question"],
                          decoration: const InputDecoration(
                            labelText: "Enter Question",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(4, (optIndex) {
                            return ListTile(
                              leading: Radio<String>(
                                value:
                                    questions[index]["options"][optIndex].text,
                                groupValue: questions[index]["correctAnswer"],
                                onChanged: (val) {
                                  setState(() {
                                    questions[index]["correctAnswer"] = val!;
                                  });
                                },
                              ),
                              title: TextField(
                                controller: questions[index]["options"]
                                    [optIndex],
                                decoration: InputDecoration(
                                    labelText: "Option ${optIndex + 1}"),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveTest,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Test"),
            ),
          ),
        ],
      ),
    );
  }
}
