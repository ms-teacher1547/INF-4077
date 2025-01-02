import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String _generateJwt(Map<String, dynamic> jsonKey) {
  final privateKey = jsonKey["private_key"];
  final clientEmail = jsonKey["client_email"];
  final now = DateTime.now();
  final exp = now.add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;

  final jwt = JWT(
    {
      "iss": clientEmail,
      "sub": clientEmail,
      "aud": "https://oauth2.googleapis.com/token",
      "iat": now.millisecondsSinceEpoch ~/ 1000,
      "exp": exp,
    },
  );

  return jwt.sign(ECPrivateKey(privateKey));
}

class DialogflowApiService {
  final String projectId = "meal-tracker-app-9ab00";
  final String sessionId = "flutter-session";
  final String apiUrl =
      "https://dialogflow.googleapis.com/v2/projects/meal-tracker-app-9ab00/agent/sessions/flutter-session:detectIntent";

  late Map<String, String> headers;

  DialogflowApiService(String s);

  // Charger et initialiser les en-têtes avec le fichier JSON
  Future<void> _initializeHeaders() async {
    final jsonString = await rootBundle.loadString('assets/meal.json');
    final jsonKey = jsonDecode(jsonString);
    final accessToken = _generateJwt(jsonKey);
    headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
  }

  // Générez un JWT à partir du fichier JSON
  String _generateJwt(Map<String, dynamic> jsonKey) {
    // Implémenter la génération de JWT ici
    throw UnimplementedError("JWT generation logic needed.");
  }

  Future<String> sendMessage(String userMessage) async {
    final body = jsonEncode({
      "queryInput": {
        "text": {
          "text": userMessage,
          "languageCode": "fr",
        }
      }
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (kDebugMode) {
        print("Response status: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Response body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['queryResult']['fulfillmentText'] ?? "Aucune réponse.";
      } else {
        return "Erreur API : ${response.body}";
      }
    } catch (e) {
      print("Exception: $e");
      return "Bot: Une erreur s'est produite.";
    }
  }

}
