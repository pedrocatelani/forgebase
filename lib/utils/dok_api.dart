import 'package:http/http.dart' as http;

class DoKApi{
  Future<Map<String, dynamic>?> getStatistics() async { 
    var deckId = "698aa648-94e2-4a71-a6f7-96d8dbb38430";
    var apiKey = "d799a9ad-1da4-492d-9656-0165be5d42d4";

    var url = Uri.parse("https://decksofkeyforge.com/public-api/v3/decks/$deckId");
    
    var response = await http.get(url, headers: {"Api-Key": apiKey});

    return {
      "Response": response
    };
  }
}