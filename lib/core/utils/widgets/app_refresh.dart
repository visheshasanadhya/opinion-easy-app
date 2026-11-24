import 'package:flutter/material.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class AppRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;

  const AppRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: color ?? AppColor.white,
      backgroundColor: backgroundColor ?? AppColor.card,
      strokeWidth: strokeWidth,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
