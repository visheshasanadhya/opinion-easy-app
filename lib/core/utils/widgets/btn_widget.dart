import 'package:flutter/material.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

/// Primary Button — solid white background, black text, with glow shadow
class PrimaryBtnWidget extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final double? horizontalPadding;

  const PrimaryBtnWidget({
    super.key,
    required this.name,
    required this.onTap,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColor.white.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary Button — transparent background, white border, white text
class SecondaryBtnWidget extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final double? horizontalPadding;

  const SecondaryBtnWidget({
    super.key,
    required this.name,
    required this.onTap,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.white.withValues(alpha: 0.12),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
