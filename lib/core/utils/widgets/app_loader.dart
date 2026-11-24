import 'package:flutter/material.dart';
import '../app_constants.dart';

class AppLoader extends StatelessWidget {
  final Color? color;
  final double? size;
  final double strokeWidth;

  const AppLoader({
    super.key,
    this.color,
    this.size,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? AppColor.white,
      ),
    );

    if (size != null) {
      indicator = SizedBox(
        width: size,
        height: size,
        child: indicator,
      );
    }

    return Center(child: indicator);
  }
}
