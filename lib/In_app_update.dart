import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateWrapper extends StatefulWidget {
  final Widget child;

  const InAppUpdateWrapper({super.key, required this.child});

  @override
  State<InAppUpdateWrapper> createState() => _InAppUpdateWrapperState();
}

class _InAppUpdateWrapperState extends State<InAppUpdateWrapper> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
