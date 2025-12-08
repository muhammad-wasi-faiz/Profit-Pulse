import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // App works without login: use 'guest' if no uid
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  CollectionReference<Map<String, dynamic>> get _cart =>
      _db.collection('carts').doc(_uid).collection('items');

  Future<void> addToCart(Map<String, dynamic> p) async {
    try {
      await _cart.add({
        'title': p['title'],
        'img': p['img'],
        'old': p['old'],
        'price': p['price'],
        'discount': p['discount'],
        'qty': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      print('addToCart error: $e\n$st');
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> cartStream() {
    try {
      return _cart.snapshots();
    } catch (e, st) {
      print('cartStream error: $e\n$st');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    final snap = await _cart.get();
    for (final d in snap.docs) {
      await d.reference.delete();
    }
  }

  Future<void> createOrder({
    required List<Map<String, dynamic>> items,
    required num total,
    required Map<String, dynamic> shipping,
  }) async {
    try {
      await _db.collection('orders').add({
        'uid': _uid,
        'items': items,
        'total': total,
        'shipping': shipping,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      print('createOrder error: $e\n$st');
      rethrow;
    }
  }

  // Quick connectivity check if needed
  Future<String> ping() async {
    try {
      await _db.collection('_health').add({'uid': _uid, 'ts': FieldValue.serverTimestamp()});
      return 'ok';
    } catch (e) {
      return 'err: $e';
    }
  }
}