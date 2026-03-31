import 'package:flutter/material.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class AppRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefresh({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.white,
      backgroundColor: AppColor.card,
      strokeWidth: 2,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
