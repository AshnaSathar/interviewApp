import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool rememberMe = false;
  bool isLoading = false;
  String errorMessage = '';

  void toggleObscureText() {
    obscureText = !obscureText;
  }

  Future<String?> login() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final userEmail = userCredential.user?.email ?? '';

      print("Firebase Initialized Successfully!");
      print("Logged-in user email: $userEmail");

      final String? role = await getUserRole(userEmail);

      if (role == null) {
        errorMessage = "Role not found for this user.";
        print(errorMessage);
        return null;
      }

      print("User role: $role");
      return role;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? "Login failed";
      print("Login failed: $errorMessage");
      return null;
    } catch (e) {
      errorMessage = "An unexpected error occurred";
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<String?> getUserRole(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user_roles')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        String role = userDoc['role'];
        print("Role found: $role");
        return role;
      } else {
        print("No document found for email: $userEmail");
        return null;
      }
    } catch (e) {
      print("Error fetching role: $e");
      return null;
    }
  }
}
