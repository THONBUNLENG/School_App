import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_notification_service.dart';

class SmsService {
  static const String _baseUrl = 'https://api.nju.edu.cn/v1/auth';

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    String cleanPhone = phoneNumber.replaceAll(' ', '');

    // Synchronized with your UI test logic
    if (cleanPhone == "011820595999") {
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

      // 201 is often used for 'Created' resources, but checking for 200 is standard
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Code sent successfully!'};
      }

      // Attempt to parse server error message if available
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Server Error: ${response.statusCode}'
      };
    } catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  static Future<String> verifyOtp(String phoneNumber, String otpCode) async {
    String cleanPhone = phoneNumber.replaceAll(' ', '');

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
        return data['success'] == true ? "success" : (data['message'] ?? "Invalid verification code.");
      }
      return "Server Error ${response.statusCode}";
    } catch (e) {
      return _handleError(e);
    }
  }

  static String _handleError(dynamic e) {
    if (e is TimeoutException) return "Connection timed out. Please try again.";
    if (e.toString().contains("SocketException")) return "No Internet connection.";
    return "Technical problem: $e";
  }
}