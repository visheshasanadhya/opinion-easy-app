import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  var scale = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  Future<void> _startSplash() async {
    final prefsRead = SharedPreferences.getInstance();

    await Future.delayed(const Duration(milliseconds: 400));
    scale.value = 1.5;

    final results = await Future.wait([
      prefsRead,
      Future.delayed(const Duration(milliseconds: 1800)),
    ]);

    final prefs = results[0] as SharedPreferences;
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed('/bottom-nav');
    } else {
      Get.offAllNamed('/login');
    }
  }
}

// import 'package:get/get.dart';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:opinion_easy/core/admob/ad_preload_service.dart';
//
// class SplashController extends GetxController {
//   var scale = 1.0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _startAnimation();
//   }
//
//   void _startAnimation() {
//     // Start zoom animation
//     Future.delayed(const Duration(milliseconds: 500), () {
//       scale.value = 1.5;
//     });
//
//     // Navigation logic
//     Future.delayed(const Duration(seconds: 3), () async {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//
//       // Try to show App Open Ad before moving to the next screen
//       final adService = Get.find<AdPreloadService>();
//
//       adService.showAppOpenAdIfAvailable(
//         onAdDismissed: () {
//           // This callback runs after the ad is closed OR if no ad was available
//           if (token != null) {
//             Get.offNamed('/bottom-nav');
//           } else {
//             Get.offNamed('/login');
//           }
//         },
//       );
//     });
//   }
// }
