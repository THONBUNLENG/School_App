import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> loginWithApi(String username, String password) async {
  final url = Uri.parse('https://your-api-endpoint.com/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true || data['token'] != null) {
        return "success";
      } else {
        return data['message'] ?? "Invalid username or password.";
      }
    } else {
      return "Server error:${response.statusCode}";
    }
  } on http.ClientException {
    return "There is a problem with the internet connection!";
  } catch (e) {
    print("API Exception: $e");
    return "There is a technical problem: $e";
  }
}