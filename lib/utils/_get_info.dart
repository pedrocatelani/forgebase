import 'package:cloud_firestore/cloud_firestore.dart';

class GetInfo {
  Future<Map<String, dynamic>> getDeckStatistics(String deckId) async {
    final doc =
        await FirebaseFirestore.instance.collection('decks').doc(deckId).get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception("Deck with ID $deckId was not found.");
    }
  }
}
