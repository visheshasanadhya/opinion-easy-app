import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opinion_easy/data/service/google_auth_service.dart';

class GoogleAuthController extends GetxController {
  var isLoading = false.obs;

  /// Full Google login flow: Step 1 → 2 → 5 → 6
  Future<bool> loginWithGoogle() async {
    try {
      isLoading.value = true;

      // Step 1: Get Google tokens from device
      final tokens = await GoogleAuthService.getGoogleTokens();
      if (tokens == null) {
        // User cancelled — no snackbar needed
        debugPrint("ℹ️ [GoogleAuth] Sign-in cancelled by user");
        return false;
      }

      final idToken = tokens['id_token']!;
      final accessToken = tokens['access_token']!;

      // Step 2: Send idToken to Laravel backend
      final response = await GoogleAuthService.sendTokenToBackend(
        idToken,
        accessToken,
      );

      // Step 5 & 6: Laravel returns user info + API token → save it
      if (response['status'] == true) {
        final prefs = await SharedPreferences.getInstance();

        // Save API token for future authenticated calls
        if (response['data'] != null && response['data']['token'] != null) {
          await prefs.setString('token', response['data']['token']);
        }

        // Optionally save user info locally
        if (response['data']?['user'] != null) {
          final user = response['data']['user'];
          await prefs.setString('user_name', user['name'] ?? '');
          await prefs.setString('user_email', user['email'] ?? '');
          await prefs.setString('user_photo', user['photo'] ?? '');
        }
        await prefs.setBool('is_google_user', true);

        return true;
      } else {
        final msg = response['message'] ?? 'Google sign-in failed';
        debugPrint("⚠️ [GoogleAuth] Backend rejected: $msg");
        Get.snackbar(
          'Oops',
          msg,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e, stack) {
      debugPrint("🔴 [GoogleAuth] Error: $e");
      debugPrint("🔴 [GoogleAuth] Stack: $stack");
      Get.snackbar(
        'Google Sign-In Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
