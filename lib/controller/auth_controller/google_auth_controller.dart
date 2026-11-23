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
        await prefs.setString('token', response['data']['token']);

        // Optionally save user info locally
        await prefs.setString(
          'user_name',
          response['data']['user']['name'] ?? '',
        );
        await prefs.setString(
          'user_email',
          response['data']['user']['email'] ?? '',
        );
        await prefs.setString(
          'user_photo',
          response['data']['user']['photo'] ?? '',
        );
        await prefs.setBool('is_google_user', true);

        return true;
      } else {
        Get.snackbar(
          'Oops',
          response['message'] ?? 'Google sign-in failed',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
