// local_notification_service.dart
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize the notification plugin
  static Future<void> initialize() async {
    // Android initialization
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Overall initialization
    const InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    // Initialize plugin
    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          print('Notification payload: ${details.payload}');
        }
      },
      onDidReceiveBackgroundNotificationResponse: (details) {
        if (details.payload != null) {
          print('Background notification payload: ${details.payload}');
        }
      },
    );

    // Request notification permission on Android 13+ (API level 33+)
    if (Platform.isAndroid) {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
      }
    }
  }

  /// Show SMS verification code notification
  static Future<void> showSmsNotification({required String code}) async {
    // Android-specific notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sms_auth_channel', // Channel ID
      'SMS Authentication', // Channel name
      channelDescription: 'Used for login verification codes',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
    );

    // iOS-specific notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    // Cross-platform notification details
    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Generate unique notification ID using milliseconds (avoid overflow)
    final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Show notification

  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
