import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/question_controller/job_fields_controller.dart';
import 'package:flutter_application_1/controller/question_controller/question_controller.dart';
import 'package:flutter_application_1/view/admin/dashboard.dart';
import 'package:flutter_application_1/view/users/full_category_page.dart';
import 'package:flutter_application_1/view/users/forget_password.dart';
import 'package:flutter_application_1/view/users/home_page.dart';
import 'package:flutter_application_1/view/users/jobs.dart';
import 'package:flutter_application_1/view/users/login_page.dart';
import 'package:flutter_application_1/view/users/nav_page.dart';
import 'package:flutter_application_1/view/users/profile_page.dart';
import 'package:flutter_application_1/view/users/question_page.dart';
import 'package:flutter_application_1/view/users/registration_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/view/users/splash_page.dart';
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
    print("Firebase Initialized Successfully!");
  } catch (e) {
    print("Error initializing Firebase: $e");
    return;
    // }
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => QuestionController()),
    ChangeNotifierProvider(create: (context) => JobFieldController()),

    // JobFieldController
  ], child: MyApp()));
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
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const FullCategoryPage(),
    ),
    GoRoute(
      path: '/nav',
      builder: (context, state) => const NavPage(),
    ),
    // GoRoute(
    //   path: '/addQuestions',
    //   builder: (context, state) => const AddQuestions(),
    // ),
    // GoRoute(
    //   path: '/questions',
    //   builder: (context, state) => const QuestionPage(),
    // ),
    GoRoute(
      path: '/forget_password',
      builder: (context, state) => const ForgetPassword(),
    ),
  ],
);
