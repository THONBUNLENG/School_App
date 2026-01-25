import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showSmsNotification({required String code}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sms_auth_channel',
      'SMS Authentication',
      channelDescription: 'Used for login verification codes',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'MESSAGES', // Title ដូច Lock Screen
      'Your verification code is: $code', // Body
      platformDetails,
    );
  }
}