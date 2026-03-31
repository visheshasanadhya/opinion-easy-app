import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeactivatedView extends StatelessWidget {
  const DeactivatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon or illustration
                Icon(
                  Icons.lock_outline_rounded,
                  size: 100,
                  color: Colors.redAccent.shade200,
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  "Account Deactivated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                const Text(
                  "Your account has been deactivated by the admin.\nPlease contact the administrator for assistance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
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
                    backgroundColor: Colors.redAccent.shade200,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Logout / Go Back Button (optional)
                // TextButton(
                //   onPressed: () => Get.offAllNamed('/login'),
                //   child: const Text(
                //     "Back to Login",
                //     style: TextStyle(fontSize: 15, color: Colors.blueAccent),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
