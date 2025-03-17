import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/application_controller.dart';
import 'package:flutter_application_1/controller/feedback_controller.dart';
import 'package:flutter_application_1/controller/job_application_controller.dart';
import 'package:flutter_application_1/controller/question_controller/job_fields_controller.dart';
import 'package:flutter_application_1/controller/question_controller/question_controller.dart';
import 'package:flutter_application_1/controller/resgister_controller.dart';
import 'package:flutter_application_1/controller/vaccancy_controller.dart';
import 'package:flutter_application_1/controller/video_controller.dart';
import 'package:flutter_application_1/view/admin/dashboard.dart';
import 'package:flutter_application_1/view/users/forget_password.dart';
import 'package:flutter_application_1/view/users/home_page.dart';
import 'package:flutter_application_1/view/users_pages/login_page.dart';
import 'package:flutter_application_1/view/users_pages/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBuZpA-UGQDmSoHyfQH3sXe_5irouzRLqI',
        appId: '1:261877854038:android:dd756a8bebdbdc5a5bb0f7',
        messagingSenderId: '261877854038',
        projectId: 'interview-f857d',
      ),
    );
    await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    print("Firebase Initialized Successfully!");
  } catch (e) {
    print("Error initializing Firebase: $e");
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JobApplicationProvider()),
        ChangeNotifierProvider(create: (context) => QuestionController()),
        ChangeNotifierProvider(create: (context) => JobFieldController()),
        ChangeNotifierProvider(create: (context) => VacancyController()),
        ChangeNotifierProvider(create: (context) => VideoController()),
        ChangeNotifierProvider(create: (context) => ApplicationController()),
        ChangeNotifierProvider(create: (context) => FeedbackController()),
        ChangeNotifierProvider(create: (context) => RegisterController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/forget_password',
      builder: (context, state) => const ForgetPassword(),
    ),
  ],
);
