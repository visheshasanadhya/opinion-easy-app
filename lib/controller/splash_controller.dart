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

