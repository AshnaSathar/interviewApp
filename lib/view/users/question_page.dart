import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/controller/question_controller/question_controller.dart';
import 'package:flutter_application_1/model/question_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class QuestionPage extends StatefulWidget {
  final String jobId;

  const QuestionPage({super.key, required this.jobId});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentPage = 0;
  int? selectedOption;
  bool showAnswer = false;
  int score = 0;
  int totalTime = 30; // 30 seconds per question
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QuestionController>().fetchQuestions(widget.jobId).then((_) {
        if (context.read<QuestionController>().questions.isNotEmpty) {
          startTimer();
        }
      });
    });
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalTime > 0) {
        setState(() {
          totalTime--;
        });
      } else {
        timer.cancel();
        nextPage(context.read<QuestionController>().questions);
      }
    });
  }

  void checkAnswer(int selected, String correctAnswer) {
    setState(() {
      showAnswer = true;
      if (context
              .read<QuestionController>()
              .questions[currentPage]
              .options[selected] ==
          correctAnswer) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      nextPage(context.read<QuestionController>().questions);
    });
  }

  void nextPage(List<QuestionModel> questions) {
    if (currentPage < questions.length - 1) {
      setState(() {
        currentPage++;
        selectedOption = null;
        showAnswer = false;
        totalTime = 30;
      });
      startTimer();
    } else {
      timer?.cancel();
      showScorePopup();
    }
  }

  void showScorePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text(
            "Your Score: $score/${context.read<QuestionController>().questions.length}\n\nPerformance: ${getPerformanceMessage()}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String getPerformanceMessage() {
    double percentage =
        (score / context.read<QuestionController>().questions.length) * 100;
    if (percentage >= 80) {
      return "Excellent! Keep it up!";
    } else if (percentage >= 50) {
      return "Good Job! Keep practicing.";
    } else {
      return "Needs Improvement. Try again!";
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

          var questions = questionController.questions;
          if (questions.isEmpty) {
            return const Center(child: Text("No questions available."));
          }

          var currentQuestion = questions[currentPage];
          int correctAnswerIndex =
              currentQuestion.options.indexOf(currentQuestion.answer);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Time Left: $totalTime sec",
                    style: const TextStyle(fontSize: 18, color: Colors.red)),
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
                            Column(
                              children: List.generate(
                                currentQuestion.options.length,
                                (index) => Card(
                                  color:
                                      showAnswer && index == correctAnswerIndex
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
                                                  currentQuestion.options[
                                                      correctAnswerIndex]);
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
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
