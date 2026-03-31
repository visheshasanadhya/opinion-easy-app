// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/auth_controller/forgot_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:pinput/pinput.dart';

class VerifyNumberView extends StatelessWidget {
  final ForgotController forgotController = Get.find<ForgotController>();
  VerifyNumberView({super.key});

  static PinTheme get _pinTheme => PinTheme(
        width: 60,
        height: 60,
        textStyle: AppText.h3,
        decoration: BoxDecoration(
          color: AppColor.cardAlt,
          borderRadius: BorderRadius.circular(AppDeco.radiusSm),
          border: Border.all(color: AppColor.borderLight),
        ),
      );

  static PinTheme get _focusedPinTheme => PinTheme(
        width: 60,
        height: 60,
        textStyle: AppText.h3,
        decoration: BoxDecoration(
          color: AppColor.cardAlt,
          borderRadius: BorderRadius.circular(AppDeco.radiusSm),
          border: Border.all(color: AppColor.white, width: 1.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/icons/logo_512.png", height: 60)),
            VS(48),
            Text("Verify Your Number", style: AppText.h2),
            VS(8),
            Text("We've sent a 4-digit code to", style: AppText.caption),
            VS(4),
            Text(
              "+91 ${forgotController.phoneController.text}",
              style: AppText.bodyMd,
            ),
            VS(28),
            Pinput(
              length: 4,
              controller: forgotController.otpController,
              keyboardType: TextInputType.number,
              defaultPinTheme: _pinTheme,
              focusedPinTheme: _focusedPinTheme,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter OTP';
                if (value.length != 4) return 'OTP must be 4 digits';
                return null;
              },
            ),
            VS(28),
            Obx(
              () => SecondaryBtnWidget(
                name:
                    forgotController.isLoading.value ? "Loading..." : "Verify",
                horizontalPadding: 40,
                onTap: () async {
                  Map<String, dynamic> requestData = {
                    'phone': forgotController.phoneController.text.trim(),
                    'otp': forgotController.otpController.text.trim(),
                  };
                  await forgotController.forgotMpin(requestData);
                },
              ),
            ),
            VS(20),
            InkWell(
              onTap: () {
                forgotController.otpController.clear();
                Get.back();
              },
              child: Text(
                "Go back",
                style: AppText.caption.copyWith(
                  color: AppColor.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
