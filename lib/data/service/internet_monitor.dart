import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/app_constants.dart';

class InternetMonitor {
  static StreamSubscription<List<ConnectivityResult>>? subscription;
  static bool wasOffline = false;
  static bool dialogVisible = false;

  static bool get isOnline => !wasOffline;
  static bool get isOffline => wasOffline;

  static Future<void> init() async {
    final results = await Connectivity().checkConnectivity();
    wasOffline = results.every((r) => r == ConnectivityResult.none);

    debugPrint('[InternetMonitor] Initial state: ${wasOffline ? "OFFLINE" : "ONLINE"}');

    if (wasOffline) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => showOfflineDialog(),
      );
    }

    subscription = Connectivity().onConnectivityChanged.listen(handleChange);
  }

  static void handleChange(List<ConnectivityResult> results) {
    final bool nowOffline = results.every((r) => r == ConnectivityResult.none);

    if (nowOffline && !wasOffline) {
      wasOffline = true;
      debugPrint('[InternetMonitor] Internet Lost');
      showOfflineDialog();
    } else if (!nowOffline && wasOffline) {
      wasOffline = false;
      debugPrint('[InternetMonitor] Internet Restored');
      closeOfflineDialog();
      Fluttertoast.showToast(
        msg: 'Back Online',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF23273A),
        textColor: Colors.white,
      );
    }
  }

  static void showOfflineDialog() {
    if (dialogVisible) return;
    dialogVisible = true;
    Get.dialog(const OfflineDialog(), barrierDismissible: false);
  }

  static void closeOfflineDialog() {
    if (!dialogVisible) return;
    dialogVisible = false;
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  static void dispose() {
    subscription?.cancel();
    subscription = null;
    debugPrint('[InternetMonitor] InternetMonitor disposed');
  }

  /// Helper to check if an exception is network-related
  static bool isNetworkError(dynamic e) {
    if (isOffline) return true;
    if (e is SocketException || e is http.ClientException) return true;
    final str = e.toString().toLowerCase();
    return str.contains('socketexception') ||
        str.contains('network is unreachable') ||
        str.contains('clientexception') ||
        str.contains('failed host lookup') ||
        str.contains('connection refused') ||
        str.contains('connection reset') ||
        str.contains('connection closed') ||
        str.contains('handshakeexception');
  }
}

class OfflineDialog extends StatelessWidget {
  const OfflineDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColor.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 52,
                color: AppColor.red,
              ),
              SizedBox(height: 16),
              Text(
                'No Internet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Check your connection',
                style: TextStyle(color: AppColor.textGrey),
              ),
              SizedBox(height: 24),
              CupertinoActivityIndicator(color: AppColor.white),
            ],
          ),
        ),
      ),
    );
  }
}
