// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/auth_controller/forgot_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:pinput/pinput.dart';

class SetMPINView extends StatelessWidget {
  final ForgotController forgotController = Get.put(ForgotController());
  SetMPINView({super.key});

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
            Text("Set Your 4-Digit MPIN", style: AppText.h2),
            VS(8),
            Text(
              "Create a secure PIN to access your account",
              textAlign: TextAlign.center,
              style: AppText.caption,
            ),
            VS(28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter MPIN", style: AppText.hint),
                VS(10),
                Pinput(
                  length: 4,
                  controller: forgotController.mpinController,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: _pinTheme,
                  focusedPinTheme: _focusedPinTheme,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter MPIN';
                    if (value.length != 4) return 'MPIN must be 4 digits';
                    return null;
                  },
                ),
                VS(18),
                Text("Confirm MPIN", style: AppText.hint),
                VS(10),
                Pinput(
                  length: 4,
                  controller: forgotController.confirmMpinController,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: _pinTheme,
                  focusedPinTheme: _focusedPinTheme,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Confirm MPIN';
                    if (value.length != 4) return 'MPIN must be 4 digits';
                    return null;
                  },
                ),
              ],
            ),
            VS(28),
            Obx(
              () => SecondaryBtnWidget(
                name: forgotController.isLoading.value ? "Loading..." : "Done",
                horizontalPadding: 80,
                onTap: () async {
                  if (forgotController.mpinController.text.isEmpty) {
                    Get.snackbar('Oops', 'Kindly enter MPIN');
                  } else if (forgotController
                      .confirmMpinController.text.isEmpty) {
                    Get.snackbar('Oops', 'Kindly confirm MPIN');
                  } else if (forgotController.mpinController.text !=
                      forgotController.confirmMpinController.text) {
                    Get.snackbar('Oops', 'MPIN does not match');
                  } else {
                    final requestData = {
                      'phone': forgotController.phoneController.text.trim(),
                      'mpin': forgotController.mpinController.text.trim(),
                    };
                    bool isSuccess = await forgotController.forgotMpin(
                      requestData,
                    );
                    if (isSuccess) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          Future.delayed(
                            const Duration(seconds: 1),
                            () => Get.offAllNamed('/login'),
                          );
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 36,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.card,
                                borderRadius: BorderRadius.circular(
                                  AppDeco.radiusLg,
                                ),
                                border: Border.all(color: AppColor.borderLight),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "🎉",
                                    style: TextStyle(fontSize: 32),
                                  ),
                                  VS(12),
                                  Text("Congrats!", style: AppText.h2),
                                  VS(10),
                                  Text(
                                    "Your MPIN has been reset successfully. Please use your new MPIN to log in.",
                                    textAlign: TextAlign.center,
                                    style: AppText.caption,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
            VS(10),
          ],
        ),
      ),
    );
  }
}
