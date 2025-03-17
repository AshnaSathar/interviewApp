import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/feedback_controller.dart';
import 'package:provider/provider.dart';

class ManageFeedback extends StatefulWidget {
  const ManageFeedback({Key? key}) : super(key: key);

  @override
  State<ManageFeedback> createState() => _ManageFeedbackState();
}

class _ManageFeedbackState extends State<ManageFeedback> {
  @override
  void initState() {
    super.initState();
    Provider.of<FeedbackController>(context, listen: false).fetchAllFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'All Feedbacks',
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<FeedbackController>(context, listen: false)
            .fetchAllFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No feedback found.'));
          }
          List<Map<String, dynamic>> feedbackList = snapshot.data!;
          return ListView.builder(
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              var feedback = feedbackList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    feedback['feedback'] ?? 'No feedback provided',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rating: ${feedback['rating'] ?? 'N/A'} ⭐',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'User: ${feedback['username'] ?? 'Unknown'}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Text(
                    feedback['timestamp'] != null
                        ? (feedback['timestamp'] as Timestamp)
                            .toDate()
                            .toString()
                        : 'Unknown Date',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
