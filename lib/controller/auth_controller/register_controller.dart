import 'package:opinion_easy/data/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  final registerKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();
  var otp = ''.obs;
  var isLoading = false.obs;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();
  final TextEditingController confirmMpinController = TextEditingController();

  Future<bool> register(Map<String, dynamic> requestData) async {
    if (!registerKey.currentState!.validate()) {
      return false;
    }

    try {
      isLoading.value = true;

      final response = await authService.register(requestData);

      if (response['status'] == true) {
        if (response['message'] == "Signup complete" &&
            response['data'] != null &&
            response['data']['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response['data']['token']);

          _clearControllers();

          Get.snackbar('Success', 'Registration successful');
        }

        return true;
      } else {
        // Handle field-specific error
        if (response['details'] is Map &&
            response['details']['field_errors'] is Map &&
            response['details']['field_errors']['phone'] != null) {
          Get.snackbar(
            'Oops',
            response['details']['field_errors']['phone'][0].toString(),
          );
        }
        if (response['details'] is Map &&
            response['details']['field_errors'] is Map &&
            response['details']['field_errors']['referral_code'] != null) {
          Get.snackbar(
            'Oops',
            response['details']['field_errors']['referral_code'][0].toString(),
          );
        } else {
          Get.snackbar('Oops', response['message'] ?? 'Registration failed');
        }
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _clearControllers() {
    nameController.clear();
    phoneController.clear();
    referralController.clear();
    otpController.clear();
    mpinController.clear();
    confirmMpinController.clear();
  }
}
