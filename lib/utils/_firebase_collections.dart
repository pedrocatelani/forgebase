import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/utils/dok_api.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class FirebaseColletion {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final dokApi = DoKApi();

  Future<void> insertUser(String email, var data) async {
    await _db.collection('users').doc(email).set(data);
  }

  Future<String> getApiKey(String userEmail) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userEmail).get();
    return doc['api_key'];
  }

  Future<void> insertDeck(
    String userEmail,
    String deckId,
    Map<String, dynamic> deckData,
  ) async {
    deckData['user_email'] = userEmail;

    await _db.collection('decks').doc(deckId).set(deckData);
  }

  Future<void> uploadUserImage(String userEmail, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      const maxSizeInBytes = 1048576;

      if (bytes.length < maxSizeInBytes) {
        final base64Image = base64Encode(bytes);

        // ignore: unnecessary_null_comparison
        if (userEmail != null) {
          await _db.collection('users').doc(userEmail).update({
            'user_image': base64Image,
          });
        }
      } else {
        final snackBar = SnackBar(
          content: Text("Image too large (larger than 1MB)"),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<Uint8List?> getUserImage(String userEmail) async {
    // ignore: unnecessary_null_comparison
    if (userEmail != null) {
      final doc = await _db.collection('users').doc(userEmail).get();
      if (doc.exists) {
        final base64Image = doc['user_image'];
        return base64Decode(base64Image);
      }
    }
    return null;
  }

  Future<void> unlinkDecksUser(String userEmail) async {
    final decksReference = _db.collection('decks');
    final querySnapshot =
        await decksReference.where('user_email', isEqualTo: userEmail).get();
    for (final doc in querySnapshot.docs) {
      await decksReference.doc(doc.id).update({'user_email': ''});
    }
  }

  Future<void> deleteUserDocument(String userEmail) async {
    _db.collection('users').doc(userEmail).delete();
  }

  Future<bool> updateApiKey(String userEmail, String apiKey) async {
    String dokiD = 'c340a4e0-eec2-4b80-b333-178b65b6f596';
    final result = await dokApi.getStatistics(dokiD, apiKey);
    if (result['status'] == 200) {
      await _db.collection('users').doc(userEmail).update({
        'api_key': apiKey.trim(),
      });
      return true;
    }
    return false;
  }
}
