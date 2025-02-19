import 'package:flutter/material.dart';
import 'package:flutter_application_1/users/view/add_questions.dart';
import 'package:flutter_application_1/users/view/full_category_page.dart';
import 'package:flutter_application_1/users/view/home/forget_password/forget_password.dart';
import 'package:flutter_application_1/users/view/home/home_page.dart';
import 'package:flutter_application_1/users/view/login_page.dart';
import 'package:flutter_application_1/users/view/nav_page.dart';
import 'package:flutter_application_1/users/view/profile/profile_page.dart';
import 'package:flutter_application_1/users/view/question_page.dart';
import 'package:flutter_application_1/users/view/registration_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/users/view/splash_page.dart';

void main() async {
  // void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
    GoRoute(
      path: '/addQuestions',
      builder: (context, state) => const AddQuestions(),
    ),
    GoRoute(
      path: '/questions',
      builder: (context, state) => const QuestionPage(),
    ),
    GoRoute(
      path: '/forget_password',
      builder: (context, state) => const ForgetPassword(),
    ),
  ],
);
