import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserController {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user_roles');

  Stream<QuerySnapshot> getUsersStream() {
    return usersCollection.snapshots();
  }

  Future<void> addUser({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      await usersCollection.add({
        'email': email,
        'username': username,
        'password': password,
        'role': role,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user: $e')),
      );
    }
  }

  void navigateToUpdateUserPage(
    BuildContext context,
    String docId,
    String email,
    String username,
    String role,
  ) {
    Navigator.pushNamed(
      context,
      '/updateUser',
      arguments: {
        'docId': docId,
        'email': email,
        'username': username,
        'role': role,
      },
    );
  }

  Future<void> deleteUser(BuildContext context, String docId) async {
    try {
      await usersCollection.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }
}
