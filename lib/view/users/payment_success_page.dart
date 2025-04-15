import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/controller/course_controller.dart';
import 'package:flutter_application_1/view/users/detailed_course_page.dart';
import 'package:provider/provider.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      final controller = Provider.of<MyCourseController>(context, listen: false)
          .selectedCourse;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedCoursePage(
            courseId: controller.id,
            title: controller.title,
            content: controller.content,
            difficulty: controller.difficulty,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: Lottie.asset(
                '/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/Animation - 1744359083976.json',
                width: 250,
                repeat: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
