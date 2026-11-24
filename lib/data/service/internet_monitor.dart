import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../core/utils/app_constants.dart';

class InternetMonitor {
  static StreamSubscription<List<ConnectivityResult>>? subscription;
  static bool wasOffline = false;
  static bool dialogVisible = false;

  static bool get isOnline => !wasOffline;
  static bool get isOffline => wasOffline;

  static Future<void> init() async {
    try {
      final results = await Connectivity().checkConnectivity();
      wasOffline = results.isEmpty || results.every((r) => r == ConnectivityResult.none);

      debugPrint('[InternetMonitor] Initial state: ${wasOffline ? "OFFLINE" : "ONLINE"}');

      if (wasOffline) {
        WidgetsBinding.instance.addPostFrameCallback((_) => showOfflineDialog());
      }

      subscription = Connectivity().onConnectivityChanged.listen(handleChange);
    } catch (e) {
      debugPrint('[InternetMonitor] Init error: $e');
    }
  }

  static void handleChange(List<ConnectivityResult> results) {
    final bool nowOffline =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);

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
    if (Get.context != null) {
      Get.dialog(
        const OfflineDialog(),
        barrierDismissible: false,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (dialogVisible && Get.context != null) {
          Get.dialog(
            const OfflineDialog(),
            barrierDismissible: false,
          );
        }
      });
    }
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
                  fontSize: 18,
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
