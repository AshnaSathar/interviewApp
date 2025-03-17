import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Debug method to print all documents in the "user_roles" collection.
  Future<void> debugPrintUserRoles() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('user_roles').get();
      for (var doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      }
    } catch (e) {
      print('Error fetching user roles: $e');
    }
  }

  Future<String> checkAndRegisterUser({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required DateTime dob,
  }) async {
    // Basic validation.
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return "All fields are required!";
    }
    if (password != confirmPassword) {
      return "Passwords do not match!";
    }
    final int age = DateTime.now().year - dob.year;
    if (age < 18) {
      return "You must be at least 18 years old!";
    }
    try {
      // Check if the email is already registered in Firestore.
      var userRoleDoc =
          await _firestore.collection('user_roles').doc(email).get();
      if (userRoleDoc.exists) {
        // Debug: Print all user_roles data.
        await debugPrintUserRoles();
        return "Account has been already registered with this email.";
      }

      // Check if the email exists in Firebase Auth.
      var methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        // The email exists. Try signing in with the provided password.
        try {
          UserCredential credential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          User? user = credential.user;
          if (user != null) {
            await user.reload();
            if (user.emailVerified) {
              // Email is verified and no Firestore record exists → register the user.
              await registerUserToRoles(email: email, username: username);
              return "User registered successfully. Please sign in.";
            } else {
              // Email not verified → send verification email.
              await user.sendEmailVerification();
              return "Email is not verified! A verification email has been sent.";
            }
          } else {
            return "Error: Unable to sign in user.";
          }
        } catch (e) {
          return "The email address is already in use. Please sign in to continue.";
        }
      } else {
        // Email does not exist in Firebase Auth → create new user.
        try {
          UserCredential credential =
              await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          User? user = credential.user;
          if (user == null) return "Failed to create user.";
          await user.sendEmailVerification();
          return "Verification email sent!";
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            return "The email address is already in use by another account.";
          } else {
            return "Error: ${e.message}";
          }
        }
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Registers the user into the "user_roles" collection in Firestore.
  // It adds assignedAt (server timestamp), email, role, and userId.
  Future<void> registerUserToRoles({
    required String email,
    required String username,
  }) async {
    User? currentUser = _auth.currentUser;
    String uid = currentUser?.uid ?? "";
    await _firestore.collection('user_roles').doc(email).set({
      'assignedAt': FieldValue.serverTimestamp(),
      'email': email,
      'role': 'user',
      'userId': uid,
      'username': username, // Optional: storing the username.
    });
  }
}
