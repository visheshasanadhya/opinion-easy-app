import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/auth_controller/forgot_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class ForgotMPINView extends StatelessWidget {
  final ForgotController forgotController = Get.put(ForgotController());
  ForgotMPINView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: forgotController.forgotKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/icons/logo_512.png", height: 60),
              ),
              VS(52),
              Text("Forgot MPIN", style: AppText.h3),
              VS(8),
              Text(
                "Forgot MPIN? Don't worry — reset in a few easy steps.",
                textAlign: TextAlign.center,
                style: AppText.caption,
              ),
              VS(28),

              // ── Phone label ──────────────────────────────
              Align(
                alignment: Alignment.topLeft,
                child: Text("Phone Number", style: AppText.hint),
              ),
              VS(8),

              // ── Phone field ──────────────────────────────
              TextFormField(
                controller: forgotController.phoneController,
                cursorColor: AppColor.white,
                style: AppText.bodyMd,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: _phoneDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Phone number is required';
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value))
                    return 'Enter a valid 10-digit phone number';
                  return null;
                },
              ),
              VS(22),

              Obx(
                () => PrimaryBtnWidget(
                  name:
                      forgotController.isLoading.value ? "Loading..." : "Send",
                  onTap: () {
                    Map<String, dynamic> requestData = {
                      'phone': forgotController.phoneController.text.trim(),
                    };
                    forgotController.forgotMpin(requestData);
                  },
                  horizontalPadding: 80,
                ),
              ),
              VS(20),

              SecondaryBtnWidget(
                onTap: () => Get.back(),
                name: "Go back",
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _phoneDecoration() {
    return InputDecoration(
      hintText: "Enter 10-digit mobile number",
      hintStyle: AppText.captionSm,
      filled: true,
      fillColor: AppColor.cardAlt,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_outlined, color: AppColor.white, size: 18),
            HS(6),
            Text("+91 ", style: AppText.bodyMd),
          ],
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.borderLight),
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.borderLight),
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColor.white, width: 1.5),
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColor.red),
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColor.red, width: 1.5),
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
      ),
    );
  }
}
