import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> registerUser(String email, String password, String userName,
      BuildContext context) async {
    try {
      setLoading(true);

      // Step 1: Check if email exists in Firebase Authentication
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        showErrorDialog(context, "Email already registered.");
        setLoading(false);
        return;
      }

      // Step 2: Check if email exists in Firestore user_roles collection
      var userRoleQuery = await _firestore
          .collection('user_roles')
          .where('email', isEqualTo: email)
          .get();

      if (userRoleQuery.docs.isNotEmpty) {
        showErrorDialog(context, "Email already registered.");
        setLoading(false);
        return;
      }

      // Step 3: If email doesn't exist, proceed with registration
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 4: Save user data in Firestore with role "user"
      await _firestore
          .collection('user_roles')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'user_name': userName,
        'email': email,
        'role': 'user', // Assign default role
        'assignedAt': FieldValue.serverTimestamp(),
      });

      // Step 5: Navigate to login page after successful registration
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      showErrorDialog(context, "Error: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }

  // Function to show an error dialog
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Registration Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
