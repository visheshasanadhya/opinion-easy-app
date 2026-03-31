import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:opinion_easy/core/admob/ad_preload_service.dart';
import 'package:opinion_easy/data/service/fcm_service.dart';
import 'package:opinion_easy/firebase_options.dart';
import 'package:opinion_easy/routes/page_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.notification == null && message.data.isNotEmpty) {
    await FCMService.showNotificationFromBackground(message);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0D0D),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    if (!kIsWeb) MobileAds.instance.initialize(),
  ]);

  await FCMService.initializeLocalNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    Get.put<AdPreloadService>(AdPreloadService());
  }

  GestureBinding.instance.resamplingEnabled = true;

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MyApp(),
  //   ),
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Opinion Easy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(context),
      getPages: pagePath,
    );
  }
}
