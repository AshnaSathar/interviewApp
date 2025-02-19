import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      prefs.setString("email", email);
      prefs.setString("password", password);
    }
  }

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        _saveCredentials(email, password);
        context.push('/nav');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
              // child: Image.asset(
              //   "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/0000038863_blue-geometric-background-vector_800.jpeg",
              //   fit: BoxFit.fill,
              // ),
            ),
            Column(
              children: [
                Container(
                  width: width,
                  height: height / 3,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Interview",
                          style: TextStyles.h1.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          "Email",
                          style: TextStyles.normalText
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyles.normalText
                                .copyWith(color: Colors.white),
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text("Password",
                            style: TextStyles.normalText
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyles.normalText
                                .copyWith(color: Colors.white),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  value: _rememberMe,
                                  activeColor: ColorConstants.secondaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value;
                                    });
                                  },
                                ),
                                Text("Remember me",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/forget_password');
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: height * .1,
                            width: width,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (!_isLoading) {
                                    _login();
                                  }
                                },
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * .06,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      border: Border.all(color: Colors.white38),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Center(
                                          child: Text(
                                            "Sign In",
                                            style: TextStyles.h3.copyWith(
                                                color: ColorConstants
                                                    .primaryColor),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ",
                                  style: TextStyle(color: Colors.white)),
                              TextButton(
                                onPressed: () {
                                  context.push('/registration');
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
