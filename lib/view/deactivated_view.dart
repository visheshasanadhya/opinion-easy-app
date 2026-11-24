import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class DeactivatedView extends StatelessWidget {
  const DeactivatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon or illustration
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 90,
                  color: AppColor.red,
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  "Account Deactivated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textWhite,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                const Text(
                  "Your account has been deactivated by the admin.\nPlease contact the administrator for assistance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColor.textGrey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // Contact Admin Button
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/help'),
                  icon: const Icon(Icons.support_agent),
                  label: const Text(
                    "Contact Admin",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    foregroundColor: AppColor.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
