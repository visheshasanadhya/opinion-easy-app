import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

class InvalidPincodeBottomSheet {
  static void show({VoidCallback? onDismissed}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
        decoration: const BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Top Right Circular Close (X) Button ──
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  onDismissed?.call();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),

            VS(10),

            // ── Red Failed Icon with Soft Pink Ring ──
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.red.withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.red.withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.red,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

            VS(18),

            // ── Title "Failed" ──
            Text("Failed", style: AppText.h3),

            VS(8),

            // ── Subtitle "Invalid Pincode ..!" ──
            Text(
              "Invalid Pincode ..!",
              style: AppText.caption.copyWith(color: AppColor.textGrey),
            ),

            VS(28),

            // ── GOT IT Action Button ──
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  onDismissed?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.white,
                  foregroundColor: AppColor.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  "GOT IT",
                  style: AppText.bodyMd.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
