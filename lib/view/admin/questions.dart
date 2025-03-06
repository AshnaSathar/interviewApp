import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (_) => TextEditingController());

  String? _correctAnswer;
  String? _selectedJobId;
  String? _selectedFieldId;
  String? _selectedJobName;

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void clearFields() {
    _questionController.clear();
    for (var controller in _optionControllers) {
      controller.clear();
    }
    _correctAnswer = null;
    _selectedJobId = null;
    _selectedFieldId = null;
    _selectedJobName = null;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchJobs() async {
    final snapshot = await FirebaseFirestore.instance.collection('jobs').get();
    return snapshot.docs;
  }

  Future<void> saveQuestion({String? questionId}) async {
    if (_questionController.text.isEmpty ||
        _optionControllers.any((c) => c.text.isEmpty) ||
        _correctAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Base data common for both add and update
    final questionData = {
      'question': _questionController.text,
      'options': _optionControllers.map((c) => c.text).toList(),
      'answer': _correctAnswer,
      'created_at': FieldValue.serverTimestamp(),
    };

    // Only include jobId and fieldId for new questions (creation)
    if (questionId == null) {
      questionData['jobId'] = _selectedJobId;
      questionData['fieldId'] = _selectedFieldId;

      await FirebaseFirestore.instance
          .collection('questions')
          .add(questionData);
    } else {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(questionId)
          .update(questionData);
    }

    clearFields();
    Navigator.pop(context);
  }

  void showQuestionDialog({
    String? questionId,
    String? initialJobId,
    String? initialFieldId,
    String? initialQuestion,
    List<String>? initialOptions,
    String? initialAnswer,
    bool isEdit = false,
  }) async {
    if (!isEdit) {
      clearFields();
    } else {
      _selectedJobId = initialJobId;
      _selectedFieldId = initialFieldId;
      _questionController.text = initialQuestion ?? '';
      for (int i = 0; i < initialOptions!.length; i++) {
        _optionControllers[i].text = initialOptions[i];
      }
      _correctAnswer = initialAnswer;
    }

    final jobDocs = await fetchJobs();

    if (isEdit && initialJobId != null) {
      final matchedJob = jobDocs.firstWhere((job) => job.id == initialJobId,
          orElse: () => jobDocs.first);
      final jobData = matchedJob.data() as Map<String, dynamic>;
      _selectedJobName = jobData['name'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  Text(questionId == null ? 'Add Question' : 'Edit Question'),
              content: SizedBox(
                width: 400,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!isEdit) ...[
                        DropdownButtonFormField(
                          value: _selectedJobId,
                          items: jobDocs.map<DropdownMenuItem<String>>((job) {
                            final jobData = job.data() as Map<String, dynamic>;
                            return DropdownMenuItem<String>(
                              value: job.id,
                              child: Text(jobData['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final selectedJob =
                                jobDocs.firstWhere((job) => job.id == value);
                            final jobData =
                                selectedJob.data() as Map<String, dynamic>;
                            setDialogState(() {
                              _selectedJobId = value;
                              _selectedFieldId = jobData['fieldId'];
                              _selectedJobName = jobData['name'];
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Select Job'),
                        ),
                      ] else ...[
                        // Text('Job: $_selectedJobName',
                        //     style:
                        //         const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                      TextField(
                        controller: _questionController,
                        decoration:
                            const InputDecoration(labelText: 'Question'),
                      ),
                      for (int i = 0; i < 4; i++)
                        TextField(
                          controller: _optionControllers[i],
                          decoration:
                              InputDecoration(labelText: 'Option ${i + 1}'),
                          onChanged: (value) {
                            setDialogState(() {});
                          },
                        ),
                      const SizedBox(height: 16),
                      const Text('Select Correct Answer',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        children:
                            _optionControllers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final controller = entry.value;
                          return RadioListTile<String>(
                            title: Text(controller.text.isNotEmpty
                                ? controller.text
                                : 'Option ${idx + 1}'),
                            value: controller.text,
                            groupValue: _correctAnswer,
                            onChanged: (value) {
                              setDialogState(() {
                                _correctAnswer = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => saveQuestion(questionId: questionId),
                  child: Text(questionId == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteQuestion(String questionId) async {
    await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Questions')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No questions found'));
          }

          final questions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final data = question.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(data['question']),
                  subtitle: Text('Correct Answer: ${data['answer']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showQuestionDialog(
                            questionId: question.id,
                            // initialJobId: data['jobId'],
                            initialFieldId: data['fieldId'],
                            initialQuestion: data['question'],
                            initialOptions: List<String>.from(data['options']),
                            initialAnswer: data['answer'],
                            isEdit: true,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteQuestion(question.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showQuestionDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
