import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_notification_service.dart';

class SmsService {
  static const String _baseUrl = 'https://api.nju.edu.cn/v1/auth';

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    String cleanPhone = phoneNumber.replaceAll(' ', '');

    // Synchronized with your UI test number
    if (cleanPhone == "011820595999") {
      // Use the same code as your UI: 0406
      await LocalNotificationService.showSmsNotification(code: "0406");
      return {'success': true, 'message': 'Test Code: 0406'};
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-sms'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'mobile': cleanPhone}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Code sent successfully!'};
      }
      return {'success': false, 'message': 'Server Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  static Future<String> verifyOtp(String phoneNumber, String otpCode) async {
    String cleanPhone = phoneNumber.replaceAll(' ', '');

    // CHECK: Ensure test code matches UI logic (0406)
    if (cleanPhone == "011820595999" && otpCode == "0406") {
      await Future.delayed(const Duration(milliseconds: 800));
      return "success";
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-sms'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': cleanPhone, 'otp': otpCode}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true ? "success" : "Invalid verification code.";
      }
      return "Server Error ${response.statusCode}";
    } catch (e) {
      return _handleError(e);
    }
  }

  static String _handleError(dynamic e) {
    if (e is TimeoutException) return "Connection timed out.";
    if (e.toString().contains("Connection closed")) {
      return "Network Error: Server rejected the connection. Check your API URL.";
    }
    return "Technical problem: $e";
  }
}