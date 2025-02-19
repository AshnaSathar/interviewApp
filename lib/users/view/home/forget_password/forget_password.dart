import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password reset link has been sent to your email")),
      );
      emailController.clear();
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong. Try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: ColorConstants.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        // backgroundColor: ColorConstants.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: height,
            width: width,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: double.infinity,
                        child: Lottie.asset(
                            "assets/images/Animation - 1739987360589.json"),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Enter your email to receive a password reset link:",
                        style: TextStyles.normalText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Reset Password",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
