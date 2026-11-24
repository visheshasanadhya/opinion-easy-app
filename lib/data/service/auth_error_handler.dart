import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthErrorHandler {
  static bool isRedirecting = false;

  /// Checks whether an HTTP response is an authentication error (401 or AUTHENTICATION_REQUIRED).
  /// If it is, displays the backend "message" in a toast, clears the saved token,
  /// and navigates the user to the login page via Get.offAllNamed('/login').
  static bool checkAuthError(http.Response response) {
    if (response.statusCode == 401 ||
        response.body.contains("AUTHENTICATION_REQUIRED") ||
        response.body.contains("You are not authenticated") ||
        response.body.contains("token is invalid")) {
      handleAuthError(response.body);
      return true;
    }
    return false;
  }

  /// Extracts message, displays toast, clears token, and redirects to '/login'.
  static void handleAuthError([String? responseBody]) {
    if (isRedirecting) return;
    isRedirecting = true;

    String toastMessage = "Authentication is required to access this resource.";
    if (responseBody != null && responseBody.isNotEmpty) {
      try {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map && decoded['message'] != null) {
          toastMessage = decoded['message'].toString();
        }
      } catch (_) {}
    }

    // 1. Show message in toast
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF23273A),
      textColor: Colors.white,
      fontSize: 14.0,
    );

    // 2. Clear token & session, redirect to /login
    Future.microtask(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('user_data');
        await prefs.remove('is_profile_complete');
      } catch (e) {
        debugPrint("Error clearing auth credentials: $e");
      }

      // Close any active dialogs / snackbars / bottom sheets
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
        Get.back();
      }

      // Navigate to login
      Get.offAllNamed('/login');

      // Keep redirect lock for 2 seconds to avoid any race condition
      await Future.delayed(const Duration(seconds: 2));
      isRedirecting = false;
    });
  }
}
