import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseColletion {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insertUser(String email, var data) async {
    await _db.collection('users').doc(email).set(data);
  }

  Future<String> getApiKey(String userEmail) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userEmail).get();
    return doc['api_key'];
  }
}
