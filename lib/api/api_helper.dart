import 'dart:convert';
import 'package:http/http.dart' as http;

class Urls {
  static const String geminiBaseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static const String apikey = "AIzaSyBYXfeZqfhG44gxEjbBmhRWjZFCdQMITUs";
}

class ApiHelper {
  /// Sends the chat messages to Gemini AI and returns the AI's response.
  Future<String?> sendMsgApi({required List<Map<String, String>> messages}) async {
    try {
      // Filter out empty messages
      final filteredMessages = messages
          .where((m) => (m['text'] ?? '').trim().isNotEmpty)
          .toList();

      if (filteredMessages.isEmpty) return null;

      final fullUrl = "${Urls.geminiBaseUrl}?key=${Urls.apikey}";

      // Prepare request body
      final body = jsonEncode({
        "contents": filteredMessages.map((m) {
          return {
            "role": m['role'] == 'user' ? 'user' : 'assistant',
            "parts": [{"text": m['text']!.trim()}]
          };
        }).toList()
      });

      // Debug logs
      print("Sending API request to: $fullUrl");
      print("Request Body: $body");

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json' },
        body: body,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return "AI No answer at this time";
        }
      } else {
        return "AI Error: Unable to contact the server.";
      }
    } catch (e) {
      print("API Exception: $e");
      return "There is a problem with the internet connection!";
    }
  }
}
