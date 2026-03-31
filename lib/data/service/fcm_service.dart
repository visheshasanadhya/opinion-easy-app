import 'dart:io';

import 'package:opinion_easy/data/service/fcm_token_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Used for important notifications.',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

class FCMService {
  static bool _localNotificationsInitialized = false;
  static bool _fcmListenersRegistered = false;

  // ── Step 1: Call from main() ───────────────────────────────

  static Future<void> initializeLocalNotifications() async {
    if (_localNotificationsInitialized) return;
    _localNotificationsInitialized = true;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTapped,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    debugPrint('✅ Local notifications initialised');
  }

  // ── Step 2: Call from HomeView.initState() ─────────────────

  static Future<void> initialize() async {
    if (_fcmListenersRegistered) return;
    _fcmListenersRegistered = true;

    await _requestPermission();

    await _saveToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint('🔄 FCM token refreshed — saving…');
      try {
        await FcmTokenService.saveFCMToken(newToken);
      } catch (e) {
        debugPrint('❌ Token refresh save failed: $e');
      }
    });

    // ── FOREGROUND ────────────────────────────────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('💬 Foreground FCM: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // ── BACKGROUND tap ────────────────────────────────────────
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🚀 Notification tapped (background): ${message.data}');
      _handleNotificationNavigation(message);
    });

    // ── TERMINATED tap ────────────────────────────────────────
    final RemoteMessage? initial = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initial != null) {
      debugPrint('🚀 App launched from terminated via notification');
      await Future.delayed(const Duration(milliseconds: 500));
      _handleNotificationNavigation(initial);
    }
  }

  // ── Called from background isolate in main() ───────────────

  static Future<void> showNotificationFromBackground(
    RemoteMessage message,
  ) async {
    final String title = message.data['title'] as String? ?? 'New Message';
    final String body = message.data['body'] as String? ?? '';

    await flutterLocalNotificationsPlugin.show(
      message.messageId?.hashCode ?? message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data.toString(),
    );
  }

  // ── Private helpers ────────────────────────────────────────

  static Future<void> _requestPermission() async {
    final NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
    debugPrint('🔔 FCM Permission: ${settings.authorizationStatus}');

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> _saveToken() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token null — will retry on next refresh.');
        return;
      }
      debugPrint('✅ FCM token obtained');
      await FcmTokenService.saveFCMToken(token);
      debugPrint('✅ FCM token saved to server');
    } catch (e) {
      debugPrint('❌ Failed to save FCM token: $e');
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    await flutterLocalNotificationsPlugin.show(
      message.messageId?.hashCode ?? message.hashCode,
      message.notification!.title ?? 'New Notification',
      message.notification!.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  @pragma('vm:entry-point')
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Local notification tapped: ${response.payload}');
    // Add navigation logic here if needed based on payload.
  }

  static void _handleNotificationNavigation(RemoteMessage message) {
    debugPrint('🗺️ Navigate from notification: ${message.data}');
    // Example: Get.toNamed(message.data['route']);
  }
}
