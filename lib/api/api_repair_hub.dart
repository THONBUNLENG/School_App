import 'dart:convert';
import 'package:http/http.dart' as http;

class RepairService {
  static Future<Map<String, dynamic>> fetchStatus() async {
    final response = await http.get(
      Uri.parse("https://mocki.io/v1/cc5b1b4b-9f63-4e36-87de-29f4f45d9c4f"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load status");
    }
  }
}
