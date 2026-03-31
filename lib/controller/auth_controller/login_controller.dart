import 'package:opinion_easy/data/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final loginKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  var isLoading = false.obs;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mpinController = TextEditingController();

  Future<bool> login(Map<String, dynamic> requestData) async {
    try {
      isLoading.value = true;
      if (!loginKey.currentState!.validate()) {
        return false;
      }
      var response = await authService.login(requestData);
      if (response['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['data']['token']);
        _clearControllers();
        return true;
      } else {
        if (response['errors'] is Map && response['errors']['phone'] != null) {
          Get.snackbar('Oops', response['errors']['phone'][0].toString());
        } else {
          Get.snackbar('Oops', response['message'] ?? 'Login failed');
        }
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
    phoneController.clear();
    mpinController.clear();
  }
}
