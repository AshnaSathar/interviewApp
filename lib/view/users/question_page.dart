import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/controller/question_controller/question_controller.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  final String jobId;

  const QuestionPage({super.key, required this.jobId});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentPage = 0;
  String selectedType = "m_c";
  int? selectedOption;
  bool showAnswer = false;

  void checkAnswer(int selected, String correctAnswer) {
    setState(() {
      showAnswer = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      nextPage(context.read<QuestionController>().questions);
    });
  }

  void nextPage(List questions) {
    if (currentPage < questions.length - 1) {
      setState(() {
        currentPage++;
        selectedOption = null;
        showAnswer = false;
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        selectedOption = null;
        showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: const Text("Questions", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<QuestionController>(
        builder: (context, questionController, child) {
          if (questionController.isLoadingQuestions) {
            return const Center(child: CircularProgressIndicator());
          }

          var filteredQuestions = questionController.questions
              .where((q) => q.job_id == widget.jobId && q.type == selectedType)
              .toList();

          if (filteredQuestions.isEmpty) {
            return const Center(
                child: Text("No questions available for this job."));
          }

          var currentQuestion = filteredQuestions[currentPage];
          bool isMultipleChoice = currentQuestion.type == 'm_c';
          int correctAnswerIndex =
              int.tryParse(currentQuestion.answer.toString()) ?? -1;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Question Type Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Multiple Choice"),
                      selected: selectedType == "m_c",
                      onSelected: (selected) =>
                          setState(() => selectedType = "m_c"),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Long Answer"),
                      selected: selectedType == "long",
                      onSelected: (selected) =>
                          setState(() => selectedType = "long"),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${currentPage + 1}: ${currentQuestion.question}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Multiple Choice Options
                            if (isMultipleChoice)
                              Column(
                                children: List.generate(
                                  currentQuestion.options.length,
                                  (index) => Card(
                                    color: showAnswer &&
                                            index == correctAnswerIndex
                                        ? Colors.green
                                        : Colors.white,
                                    child: ListTile(
                                      leading: Radio<int>(
                                        value: index,
                                        groupValue: selectedOption,
                                        activeColor: Colors.green,
                                        onChanged: selectedOption == null
                                            ? (int? value) {
                                                setState(() {
                                                  selectedOption = value;
                                                });
                                                checkAnswer(
                                                    value!,
                                                    currentQuestion.answer
                                                        .toString());
                                              }
                                            : null,
                                      ),
                                      title: Text(
                                        currentQuestion.options[index],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 15),

                            if (showAnswer)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Correct Answer: ${currentQuestion.options[correctAnswerIndex]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Buttons
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 0 ? previousPage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            currentPage > 0 ? Colors.blueAccent : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Previous"),
                    ),
                    ElevatedButton(
                      onPressed: currentPage < filteredQuestions.length - 1
                          ? () => nextPage(filteredQuestions)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            currentPage < filteredQuestions.length - 1
                                ? Colors.blueAccent
                                : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
