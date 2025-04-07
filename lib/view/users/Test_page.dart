import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';

class QuizScreen extends StatefulWidget {
  final String courseId; // Actual course document ID.
  final String difficulty; // e.g., "easy", "medium", "hard"

  const QuizScreen({
    Key? key,
    required this.courseId,
    required this.difficulty,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  int score = 0;
  bool quizCompleted = false;
  String? selectedAnswer;
  String? correctAnswer;
  Timer? _timer;
  int timeLeft = 10; // seconds per question
  bool anyWrong = false;

  List<Map<String, dynamic>> suggestedCourses = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final String courseDocId = widget.courseId;
      final String path =
          "courses/${widget.difficulty}/course/$courseDocId/questions";
      print("Fetching questions from: $path");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.difficulty)
          .collection('course')
          .doc(courseDocId)
          .collection('questions')
          .get();

      print("Fetched ${snapshot.docs.length} questions");

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
          questions = [];
        });
        return;
      }

      List<Map<String, dynamic>> fetchedQuestions = snapshot.docs.map((doc) {
        return {
          "question": doc.get("question"),
          "options": List<String>.from(doc.get("options")),
          "correctAnswer": doc.get("correctAnswer"),
          "id": doc.id,
        };
      }).toList();

      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
      });
      startTimer();
    } catch (e) {
      print("Error fetching questions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      timeLeft = 10;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        // Time's up for the current question.
        if (selectedAnswer == null) {
          anyWrong = true;
        }
        _timer?.cancel();
        goToNextQuestion();
      }
    });
  }

  void selectAnswer(String answer) {
    if (quizCompleted) return;
    // Cancel timer when answer is selected
    _timer?.cancel();
    setState(() {
      selectedAnswer = answer;
      correctAnswer = questions[currentQuestionIndex]["correctAnswer"];
      if (answer == correctAnswer) {
        score++;
      } else {
        anyWrong = true;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      goToNextQuestion();
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        correctAnswer = null;
      });
      startTimer();
    } else {
      _timer?.cancel();
      setState(() {
        quizCompleted = true;
      });
      showResultDialog();
    }
  }

  Future<void> fetchSuggestedCourses() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.difficulty)
          .collection('course')
          .where(FieldPath.documentId, isNotEqualTo: widget.courseId)
          .limit(3)
          .get();

      List<Map<String, dynamic>> courses = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data["id"] = doc.id;
        return data;
      }).toList();

      setState(() {
        suggestedCourses = courses;
      });
    } catch (e) {
      print("Error fetching suggested courses: $e");
    }
  }

  void showResultDialog() async {
    if (!anyWrong) {
      await fetchSuggestedCourses();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (anyWrong) {
          return AlertDialog(
            title: const Text("Quiz Completed"),
            content: Text(
                "You scored $score out of ${questions.length}.\nIt seems one or more answers were incorrect. Would you like to review the course?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back to course page
                },
                child: const Text("Review Course"),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Excellent!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("You scored $score out of ${questions.length}."),
                const SizedBox(height: 16),
                const Text("Other courses you might like:"),
                ...suggestedCourses.map((course) {
                  return ListTile(
                    title: Text(course['title'] ?? "No Title"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back to course page
                },
                child: const Text("Close"),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("No questions found.")),
      );
    }

    if (quizCompleted) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Quiz Completed",
              style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Text(
            "You scored $score out of ${questions.length}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];
    List<String> options = currentQuestion["options"];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: Text(
          "Quiz (${currentQuestionIndex + 1}/${questions.length}) | Time Left: $timeLeft s",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion["question"],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...options.map((option) {
              Color buttonColor = Colors.white;
              if (selectedAnswer != null) {
                if (option == correctAnswer) {
                  buttonColor = Colors.green;
                } else if (option == selectedAnswer) {
                  buttonColor = Colors.red;
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: selectedAnswer == null
                      ? () => selectAnswer(option)
                      : null,
                  child: Text(option,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
