import 'package:http/http.dart' as http;
import 'dart:convert';


class DoKApi{
  Future<Map<dynamic, dynamic>> getStatistics() async { 
    var deckId = "698aa648-94e2-4a71-a6f7-96d8dbb38430";
    var apiKey = "d799a9ad-1da4-492d-9656-0165be5d42d4";

    var url = Uri.parse("https://decksofkeyforge.com/public-api/v3/decks/$deckId");
    
    var response = await http.get(url, headers: {"Api-Key": apiKey});

    if (response.statusCode == 200) {
   
      return {
        "status": response.statusCode,
        "deck": deckParse(json.decode(response.body)["deck"])
      };
    }

    else{
      return {"status": response.statusCode};
    }
  }


  Map<dynamic, dynamic> deckParse(var deck) {

    List houses = [];

    for (var house in deck["housesAndCards"]){
      Map houseDict = {
        "name": house["house"],
        "cards": []
      };

      for (var card in house["cards"]){
        houseDict["cards"].add([house["house"],card["cardTitle"], card["cardTitleUrl"]]);
      }
        
      houses.add(houseDict);
    }

    var parsed = {
      "vaulId": deck["keyforgeId"],
      "name": deck["name"],
      "expansion": deck["expansion"],
      "sas": deck["sasRating"],
      "aerc": deck["aercScore"],
      "synergy": deck["synergyRating"],
      "antiSynergy": deck["antisynergyRating"],
      "sasPercentile": deck["sasPercentile"],
      "creatureCount": deck["creatureCount"],
      "actionCount": deck["actionCount"],
      "artifactCount": deck["artifactCount"],
      "upgradeCount": deck["upgradeCount"],
      "expectedAmber": deck["expectedAmber"],
      "amberControl": deck["amberControl"],
      "creatureControl": deck["creatureControl"],
      "efficiency": deck["efficiency"],
      "recursion": deck["recursion"],
      "effectivePower": deck["effectivePower"],
      "creatureProtection": deck["creatureProtection"],
      "disruption": deck["disruption"],
      "other": deck["other"],
      "bonusAmber": deck["rawAmber"],
      "houses": houses,
      "synergies": deck["synergyDetails"]
    };

    return parsed;
  }
}