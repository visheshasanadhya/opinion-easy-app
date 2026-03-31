import 'package:opinion_easy/data/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  var isLoading = false.obs;

  final forgotKey = GlobalKey<FormState>();

  final authService = AuthService();

  // Text Controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();
  final TextEditingController confirmMpinController = TextEditingController();

  Future<bool> forgotMpin(Map<String, dynamic> requestData) async {
    try {
      if (forgotKey.currentState!.validate()) {
        isLoading.value = true;

        var response = await authService.fotgotMpin(requestData);

        if (response['status'] == true) {
          if (response['step'] == "otp_sent") {
            Get.toNamed('/verify-number');
          }
          if (response['step'] == "otp_verified") {
            Get.offNamed('/set-mpin');
          }
          if (response['step'] == "mpin_updated") {
            _clearControllers();
          }

          return true;
        } else {
          Get.snackbar('Oops', response['message'] ?? 'Login failed');
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar('Oops', e.toString());
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
