import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // Boolean to track filter selection
  bool isMultipleChoice = false;

  // Sample set of questions
  List<Map<String, dynamic>> multipleChoiceQuestions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Madrid'],
      'answer': 'Paris'
    },
    {
      'question': 'Which is the largest planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
      'answer': 'Jupiter'
    }
  ];

  List<Map<String, dynamic>> longAnswerQuestions = [
    {
      'question': 'Explain the process of photosynthesis.',
      'answer': 'Photosynthesis is the process by which plants use sunlight...',
    },
    {
      'question': 'Describe the laws of motion.',
      'answer':
          'Newton’s laws of motion explain the relationship between a body and the forces acting upon it...',
    }
  ];

  int currentPage = 0;

  // Handle pagination
  void nextPage() {
    setState(() {
      if (currentPage <
          (isMultipleChoice
                  ? multipleChoiceQuestions.length
                  : longAnswerQuestions.length) -
              1) {
        currentPage++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var questions =
        isMultipleChoice ? multipleChoiceQuestions : longAnswerQuestions;
    var currentQuestion = questions[currentPage];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Question & Answer Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox Filter
            Row(
              children: [
                Checkbox(
                  value: isMultipleChoice,
                  onChanged: (bool? value) {
                    setState(() {
                      isMultipleChoice = value!;
                      currentPage = 0; // Reset page when filter changes
                    });
                  },
                ),
                const Text("Multiple Choice"),
                Checkbox(
                  value: !isMultipleChoice,
                  onChanged: (bool? value) {
                    setState(() {
                      isMultipleChoice = !value!;
                      currentPage = 0; // Reset page when filter changes
                    });
                  },
                ),
                const Text("Long Answer"),
              ],
            ),

            // Question Display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Number and Text
                  Text(
                    'Q${currentPage + 1}: ${currentQuestion['question']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  // Options for Multiple Choice
                  if (isMultipleChoice)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        currentQuestion['options'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Radio(
                                value: index,
                                groupValue: null,
                                onChanged: (value) {},
                              ),
                              Text(currentQuestion['options'][index]),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Show Answer Button and the answer section
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Answer"),
                            content: Text(isMultipleChoice
                                ? 'Correct Answer: ${currentQuestion['answer']}'
                                : currentQuestion['answer']),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Show Answer'),
                  ),
                ],
              ),
            ),

            // Pagination
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousPage,
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
