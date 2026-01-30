import 'dart:convert';
import 'package:http/http.dart' as http;
class TopUpService {
  static const String _baseUrl = "https://api.beltel_is.edu.kh/v1";

  static Future<Map<String, dynamic>> submitTopUp({
    required double amount,
    required String method,
    required String note,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/v1"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_ACCESS_TOKEN",
        },
        body: jsonEncode({
          "amount": amount,
          "payment_method": method,
          "description": note,
          "currency": "CNY",
          "timestamp": DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 15));

      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Network error. Please check your connection."};
    }
  }
}