// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_application_1/constants/color_constants.dart';
// import 'package:flutter_application_1/constants/textstyle_constants.dart';
// import 'package:flutter_application_1/view/users/custom_pages/custom_text_field.dart';

// class RoleConstants {
//   static const String user = "user";
// }

// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({super.key});

//   @override
//   State<RegistrationPage> createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController confirmPassController = TextEditingController();

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   Future<void> _registerUser() async {
//     String name = nameController.text.trim();
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String confirmPassword = confirmPassController.text.trim();

//     if (name.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       _showSnackBar("All fields are required!");
//       return;
//     }

//     if (password != confirmPassword) {
//       _showSnackBar("Passwords do not match!");
//       return;
//     }

//     try {
//       // Create the user account
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       User? user = userCredential.user;

//       if (user != null) {
//         // Send verification email
//         await user.sendEmailVerification();
//         // Show a dialog prompting the user to verify their email
//         _showEmailVerificationDialog(user, name, email);
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-already-in-use') {
//         _showSnackBar("Email is already registered!");
//       } else if (e.code == 'weak-password') {
//         _showSnackBar("Password should be at least 6 characters!");
//       } else {
//         _showSnackBar("Registration failed: ${e.message}");
//       }
//     } catch (e) {
//       _showSnackBar("An error occurred: ${e.toString()}");
//     }
//   }

//   void _showEmailVerificationDialog(User user, String name, String email) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: const Text('Verify Your Email'),
//           content: const Text(
//               'A verification link has been sent to your email. Please verify your email and then click "I have verified".'),
//           actions: [
//             TextButton(
//               style: ButtonStyle(
//                 foregroundColor: MaterialStateProperty.all(Colors.white),
//                 backgroundColor: MaterialStateProperty.all(
//                     const Color.fromARGB(255, 7, 59, 8)),
//               ),
//               onPressed: () async {
//                 await user.reload();
//                 User? updatedUser = FirebaseAuth.instance.currentUser;
//                 if (updatedUser != null && updatedUser.emailVerified) {
//                   await _completeRegistration(updatedUser, name, email);
//                   Navigator.of(context).pop();
//                   context.push('/');
//                 } else {
//                   _showSnackBar(
//                       'Email not verified yet. Please check your email.');
//                 }
//               },
//               child: const Text('I have verified'),
//             ),
//             TextButton(
//               style: ButtonStyle(
//                 foregroundColor: MaterialStateProperty.all(Colors.white),
//                 backgroundColor: MaterialStateProperty.all(Colors.red),
//               ),
//               onPressed: () async {
//                 await user.sendEmailVerification();
//                 _showSnackBar('Verification email resent.');
//               },
//               child: const Text('Resend Email'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _completeRegistration(
//       User user, String name, String email) async {
//     String userId = user.uid;
//     await FirebaseFirestore.instance.collection('user_roles').doc(userId).set({
//       'assignedAt': FieldValue.serverTimestamp(),
//       'email': email,
//       'role': RoleConstants.user,
//       'userId': userId,
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString("userName", name);
//     await prefs.setString("userEmail", email);
//     await prefs.setString("userRole", RoleConstants.user);
//     await prefs.setBool("isLoggedIn", true);

//     _showSnackBar("Registration Successful!");
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.sizeOf(context).height;
//     var width = MediaQuery.sizeOf(context).width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back)),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: MediaQuery.sizeOf(context).height * .3,
//             child: Image.asset(
//                 "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/interview.jpeg"),
//           ),
//           Center(
//             child: SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxHeight: height * 0.85),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("Create an account",
//                           style: TextStyles.h5.copyWith(color: Colors.black)),
//                       const SizedBox(height: 5),
//                       CustomTextField(
//                           label: "Name",
//                           controller: nameController,
//                           icon: Icons.person),
//                       const SizedBox(height: 5),
//                       CustomTextField(
//                           label: "Email",
//                           controller: emailController,
//                           icon: Icons.email),
//                       const SizedBox(height: 5),
//                       CustomTextField(
//                         label: "Password",
//                         controller: passwordController,
//                         icon: Icons.lock,
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 5),
//                       CustomTextField(
//                         label: "Confirm Password",
//                         controller: confirmPassController,
//                         icon: Icons.lock,
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 30),
//                       SizedBox(
//                         height: 50,
//                         width: width,
//                         child: ElevatedButton(
//                           onPressed: _registerUser,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30)),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 40),
//                           ),
//                           child: Text("Sign Up",
//                               style:
//                                   TextStyles.h6.copyWith(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
