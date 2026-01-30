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
      return "Invalid username or password (test).";
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
        return data['message'] ?? "Incorrect username or password.";
      }
    } else {
      return "Error Server: ${response.statusCode}";
    }
  } on SocketException {
    return "Unable to connect to the server! Please check your VPN.";
  } on TimeoutException {
    return "Connection too slow (Timeout). Please try again.";
  } catch (e) {
    return "Technical problems: $e";
  }
}