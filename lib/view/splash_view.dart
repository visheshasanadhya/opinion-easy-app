// splash_screen.dart
import 'package:opinion_easy/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(
          () => AnimatedScale(
            scale: controller.scale.value,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/icons/logo_512.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
