import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/users/view/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  // Future<void> _registerUser() async {
  //   String name = nameController.text.trim();
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   String confirmPassword = confirmPassController.text.trim();

  //   if (name.isEmpty ||
  //       email.isEmpty ||
  //       password.isEmpty ||
  //       confirmPassword.isEmpty) {
  //     _showSnackBar("All fields are required!");
  //     return;
  //   }

  //   if (password != confirmPassword) {
  //     _showSnackBar("Passwords do not match!");
  //     return;
  //   }

  //   // Save user data to SharedPreferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("userName", name);
  //   await prefs.setString("userEmail", email);
  //   await prefs.setBool("isLoggedIn", true);

  //   _showSnackBar("Registration Successful!");

  //   // Navigate to Home Screen
  //   context.push('/');
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPassController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar("All fields are required!");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match!");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userName", name);
      await prefs.setString("userEmail", email);
      await prefs.setBool("isLoggedIn", true);

      _showSnackBar("Registration Successful!");

      context.push('/');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showSnackBar("Email is already registered!");
      } else if (e.code == 'weak-password') {
        _showSnackBar("Password should be at least 6 characters!");
      } else {
        _showSnackBar("Registration failed: ${e.message}");
      }
    } catch (e) {
      _showSnackBar("An error occurred: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    transform: GradientRotation(1.5),
                    colors: [
                  ColorConstants.primaryColor,
                  ColorConstants.secondaryColor
                ])),
          ),
          // SizedBox(
          //   height: height,
          //   width: width,
          //   child: Image.asset(
          //     "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/0000038863_blue-geometric-background-vector_800.jpeg",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height * 0.85,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Create an account",
                          style: TextStyles.h2.copyWith(color: Colors.white)),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: "Name",
                        controller: nameController,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: "Email",
                        controller: emailController,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: "Password",
                        controller: passwordController,
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: "Confirm Password",
                        controller: confirmPassController,
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: width,
                        child: ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyles.h4
                                .copyWith(color: ColorConstants.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
