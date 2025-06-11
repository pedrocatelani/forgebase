import 'package:http/http.dart' as http;
import 'dart:convert';

class DoKApi {
  Future<Map<dynamic, dynamic>> getStatistics(String deckId, String apiKey) async {
    // var deckId = "698aa648-94e2-4a71-a6f7-96d8dbb38430";
    // var apiKey = "00868570-ba82-44e0-a6c5-40d37c438d19";

    var url = Uri.parse(
      "https://decksofkeyforge.com/public-api/v3/decks/$deckId",
    );

    var response = await http.get(url, headers: {"Api-Key": apiKey});

    if (response.statusCode == 200) {
      return {
        "status": response.statusCode,
        "deck": deckParse(json.decode(utf8.decode(response.bodyBytes))["deck"]),
      };
    } else {
      return {"status": response.statusCode};
    }
  }

  Map<dynamic, dynamic> deckParse(var deck) {
    List houses = [];
    List houseNames = [];

    for (var house in deck["housesAndCards"]) {
      houseNames.add(house["house"]);

      Map houseDict = {"name": house["house"], "cards": []};

      for (var card in house["cards"]) {
        houseDict["cards"].add({
          "title": card["cardTitle"],
          "url": card["cardTitleUrl"],
        });
      }

      houses.add(houseDict);
    }

    var parsed = {
      "vaulId": deck["keyforgeId"] ?? 0,
      "name": deck["name"],
      "expansion": deck["expansion"],
      "sas": deck["sasRating"] ?? 0,
      "aerc": deck["aercScore"] ?? 0,
      "synergy": deck["synergyRating"] ?? 0,
      "antiSynergy": deck["antisynergyRating"] ?? 0,
      "sasPercentile": deck["sasPercentile"] ?? 0,
      "creatureCount": deck["creatureCount"] ?? 0,
      "actionCount": deck["actionCount"] ?? 0,
      "artifactCount": deck["artifactCount"] ?? 0,
      "upgradeCount": deck["upgradeCount"] ?? 0,
      "expectedAember": deck["expectedAmber"] ?? 0,
      "aemberControl": deck["amberControl"] ?? 0,
      "creatureControl": deck["creatureControl"] ?? 0,
      "efficiency": deck["efficiency"] ?? 0,
      "recursion": deck["recursion"] ?? 0,
      "effectivePower": deck["effectivePower"] ?? 0,
      "creatureProtection": deck["creatureProtection"] ?? 0,
      "disruption": deck["disruption"] ?? 0,
      "other": deck["other"] ?? 0,
      "bonusAember": deck["rawAmber"] ?? 0,
      "totalPower": deck["totalPower"] ?? 0,
      "totalArmor": deck["totalArmor"] ?? 0,
      "archivesTargetted": deck["cardArchiveCount"] ?? 0,
      "archivesRandom": deck["cardDrawCount"] ?? 0,
      "keyCheatCount": deck["keyCheatCount"] ?? 0,
      "houses": houses,
      "housesNames": houseNames,
      "lastSasUpdate": deck["lastSasUpdate"] ?? 0,
    };
    
    return parsed;
  }


  Future<Map<dynamic, dynamic>> importDoKDecks(String apiKey) async {
    var url = Uri.parse(
      "https://decksofkeyforge.com/public-api/v1/my-decks?page=0",
    );

    var response = await http.get(url, headers: {"Api-Key": apiKey});

    if (response.statusCode == 200) {
      List decks = [];

      for (var deck in json.decode(utf8.decode(response.bodyBytes))) {
        decks.add(deckParse(deck["deck"]));
      } 

      return {
        "status": response.statusCode,
        "decks": decks,
      };
    } else {
      return {"status": response.statusCode};
    }
  }
}
