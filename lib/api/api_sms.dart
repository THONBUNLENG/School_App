import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> loginWithApi(String username, String password, {bool isTestMode = true}) async {
  if (isTestMode) {
    await Future.delayed(const Duration(seconds: 2));

    if (username == "admin" && password == "@Bunleng520") {
      return "success";
    } else {
      return "ឈ្មោះអ្នកប្រើ ឬលេខសម្ងាត់មិនត្រឹមត្រូវ (តេស្ត)។";
    }
  }

  // ---  Server pit---
  final url = Uri.parse('https://your-api-endpoint.com/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15)); //  VPN

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true || data['token'] != null) {
        return "success";
      } else {
        return data['message'] ?? "ឈ្មោះអ្នកប្រើ ឬលេខសម្ងាត់មិនត្រឹមត្រូវ។";
      }
    } else {
      return "កំហុស Server: ${response.statusCode}";
    }
  } on SocketException {
    return "មិនអាចតភ្ជាប់ទៅកាន់ Server បានទេ! សូមពិនិត្យ VPN របស់អ្នក។";
  } on TimeoutException {
    return "ការតភ្ជាប់យឺតពេក (Timeout) សូមព្យាយាមម្ដងទៀត។";
  } catch (e) {
    return "មានបញ្ហាបច្ចេកទេស: $e";
  }
}