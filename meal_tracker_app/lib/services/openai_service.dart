import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = "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"; // Remplace par ta clé API
  final String _apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // Modèle à utiliser (peut être adapté)
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": userMessage},
          ],
          "max_tokens": 200,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botMessage = data["choices"][0]["message"]["content"];
        return botMessage;
      } else {
        return "Erreur API : ${response.body}";
      }
    } catch (e) {
      return "Erreur lors de l'envoi du message : $e";
    }
  }
}
