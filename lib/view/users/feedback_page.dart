import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/feedback_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 3.0;
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    final feedbackProvider =
        Provider.of<FeedbackController>(context, listen: false);
    await feedbackProvider.submitFeedback(_rating, _feedbackController.text);

    // Show success popup
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Feedback Submitted"),
        content: const Text("Thank you for your feedback!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    // Clear the fields after submission
    _feedbackController.clear();
    setState(() {
      _rating = 3.0; // Reset rating to default
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rate your experience:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Your Feedback:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your feedback...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                child: const Text("Submit Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
