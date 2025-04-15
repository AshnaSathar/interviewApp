import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardController {
  Future<void> addCard({
    required String cardNumber,
    required String expiry,
    required String cvv,
    required bool isDefault,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      throw Exception("User not logged in.");
    }
    final email = currentUser.email!;

    final cardData = {
      'email': email,
      'cardNumber': cardNumber,
      'expiry': expiry,
      'cvv': cvv,
      'isDefault': isDefault,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('user_cards')
        .doc(email)
        .set(cardData, SetOptions(merge: true));
  }
}
