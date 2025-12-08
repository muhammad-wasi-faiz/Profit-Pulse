import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  final _db = FirebaseFirestore.instance;

  Future<void> submit({
    required String name,
    required String email,
    required String message,
  }) async {
    await _db.collection('feedback').add({
      'name': name,
      'email': email,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}