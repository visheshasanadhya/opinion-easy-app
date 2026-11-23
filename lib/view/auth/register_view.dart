// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:opinion_easy/controller/auth_controller/google_auth_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/auth_controller/register_controller.dart';

class RegisterView extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());

  RegisterView({super.key});

  // ── Shared decorations ─────────────────────────────────────

  static InputDecoration _fieldDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      hintText: hint,
      hintStyle: AppText.captionSm,
      filled: true,
      fillColor: AppColor.cardAlt,
      prefixIcon: prefix,
      prefixIconConstraints: prefix != null
          ? const BoxConstraints(minWidth: 0, minHeight: 0)
          : null,
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

  static Widget get _phonePrefix => Padding(
        padding: const EdgeInsets.only(left: 14, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_outlined, color: AppColor.white, size: 18),
            HS(6),
            Text("+91 ", style: AppText.bodyMd),
          ],
        ),
      );

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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(text, style: AppText.hint),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: SafeArea(
        child: Form(
          key: registerController.registerKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  VS(48),
                  Center(
                    child: Image.asset(
                      "assets/icons/logo_512.png",
                      height: 100,
                    ),
                  ),
                  VS(12),
                  Text("Welcome to Opinion Easy", style: AppText.h3),
                  VS(4),
                  Text("Earning Reward and Gift", style: AppText.caption),
                  VS(32),

                  // ── Name ──────────────────────────────
                  _label("Name"),
                  TextFormField(
                    controller: registerController.nameController,
                    cursorColor: AppColor.white,
                    style: AppText.bodyMd,
                    decoration: _fieldDecoration("Enter Your Full Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Name is required';
                      if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value))
                        return 'Name can contain only letters and spaces';
                      return null;
                    },
                  ),
                  VS(14),

                  // ── Phone ─────────────────────────────
                  _label("Phone Number"),
                  TextFormField(
                    controller: registerController.phoneController,
                    cursorColor: AppColor.white,
                    style: AppText.bodyMd,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _fieldDecoration(
                      "Enter 10-digit mobile number",
                      prefix: _phonePrefix,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Phone number is required';
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value))
                        return 'Enter a valid 10-digit phone number';
                      return null;
                    },
                  ),
                  VS(14),

                  // ── Referral Code ─────────────────────
                  _label("Referral Code"),
                  TextFormField(
                    controller: registerController.referralController,
                    cursorColor: AppColor.white,
                    style: AppText.bodyMd,
                    decoration: _fieldDecoration(
                      "Enter Referral Code (optional)",
                    ),
                  ),
                  VS(24),

                  Obx(
                    () => PrimaryBtnWidget(
                      name: registerController.isLoading.value
                          ? "Loading..."
                          : "Next — OTP Verification",
                      onTap: () async {
                        final requestData = {
                          'name': registerController.nameController.text.trim(),
                          'phone':
                              registerController.phoneController.text.trim(),
                          'referral_code':
                              registerController.referralController.text.trim(),
                        };
                        bool? isSuccess = await registerController.register(
                          requestData,
                        );
                        if (isSuccess == true) {
                          registerController.otpController.clear();
                          _otpSheet(context);
                        }
                      },
                    ),
                  ),
                  VS(16),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColor.borderLight)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text("OR", style: AppText.captionSm),
                      ),
                      Expanded(child: Divider(color: AppColor.borderLight)),
                    ],
                  ),
                  VS(16),

                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: googleAuthController.isLoading.value
                            ? null
                            : () async {
                                bool success = await googleAuthController
                                    .loginWithGoogle();
                                if (success) {
                                  Get.offAllNamed('/bottom-nav');
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.borderLight),
                          backgroundColor: AppColor.cardAlt,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDeco.radiusSm),
                          ),
                        ),
                        child: googleAuthController.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/google_logo.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  HS(10),
                                  Text("Sign up with Google",
                                      style: AppText.bodyMd),
                                ],
                              ),
                      ),
                    ),
                  ),

                  VS(20),

                  InkWell(
                    onTap: () => Get.offNamed('/login'),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an Account? ",
                            style: AppText.bodyMd,
                          ),
                          TextSpan(
                            text: "Sign In",
                            style: AppText.bodyMd.copyWith(
                              color: AppColor.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VS(32),

                  Text(
                    "By proceeding, I confirm that I agree to the",
                    style: AppText.captionSm,
                  ),
                  VS(2),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/terms-and-conditions');
                    },
                    child: Text(
                      "Terms and Conditions.",
                      style: AppText.captionSm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                  VS(32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── OTP sheet ────────────────────────────────────────────────

  Future<dynamic> _otpSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColor.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColor.cardLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text("Verify Your Number", style: AppText.h2),
                VS(8),
                Text("We've sent a 4-digit code to", style: AppText.caption),
                VS(2),
                Text(
                  "+91 ${registerController.phoneController.text}",
                  style: AppText.bodyMd,
                ),
                VS(28),
                Pinput(
                  length: 4,
                  controller: registerController.otpController,
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
                    name: registerController.isLoading.value
                        ? "Loading..."
                        : "Verify",
                    horizontalPadding: 40,
                    onTap: () async {
                      final requestData = {
                        'name': registerController.nameController.text.trim(),
                        'phone': registerController.phoneController.text.trim(),
                        'referral_code':
                            registerController.referralController.text.trim(),
                        'otp': registerController.otpController.text.trim(),
                      };
                      if (registerController.otpController.text.isNotEmpty) {
                        bool isSuccess = await registerController.register(
                          requestData,
                        );
                        if (isSuccess) {
                          Navigator.pop(context);
                          _setMPinSheet(context);
                        }
                      } else {
                        Get.snackbar('Oops', 'Kindly enter OTP');
                      }
                    },
                  ),
                ),
                VS(16),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Set MPIN sheet ───────────────────────────────────────────

  Future<dynamic> _setMPinSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColor.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColor.cardLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text("Set Your 4-Digit MPIN", style: AppText.h2),
                VS(8),
                Text(
                  "Create a secure PIN to access your account",
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
                      controller: registerController.mpinController,
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
                      controller: registerController.confirmMpinController,
                      keyboardType: TextInputType.number,
                      defaultPinTheme: _pinTheme,
                      focusedPinTheme: _focusedPinTheme,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Confirm MPIN';
                        if (value.length != 4) return 'MPIN must be 4 digits';
                        return null;
                      },
                    ),
                  ],
                ),
                VS(28),
                Obx(
                  () => SecondaryBtnWidget(
                    name: registerController.isLoading.value
                        ? "Loading..."
                        : "Done",
                    horizontalPadding: 80,
                    onTap: () async {
                      if (registerController.mpinController.text.isEmpty) {
                        Get.snackbar('Oops', 'Kindly enter MPIN');
                      } else if (registerController
                          .confirmMpinController.text.isEmpty) {
                        Get.snackbar('Oops', 'Kindly confirm MPIN');
                      } else if (registerController.mpinController.text !=
                          registerController.confirmMpinController.text) {
                        Get.snackbar('Oops', 'MPIN does not match');
                      } else {
                        final requestData = {
                          'name': registerController.nameController.text.trim(),
                          'phone':
                              registerController.phoneController.text.trim(),
                          'referral_code':
                              registerController.referralController.text.trim(),
                          'otp': registerController.otpController.text.trim(),
                          'mpin': registerController.mpinController.text.trim(),
                        };
                        bool isSuccess = await registerController.register(
                          requestData,
                        );
                        if (isSuccess) {
                          Get.back();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              Future.delayed(
                                const Duration(seconds: 1),
                                () => Get.offAllNamed('/bottom-nav'),
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
                                    border: Border.all(
                                      color: AppColor.borderLight,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "🎉",
                                        style: TextStyle(fontSize: 32),
                                      ),
                                      VS(12),
                                      Text(
                                        "Account Successfully\nCreated",
                                        textAlign: TextAlign.center,
                                        style: AppText.h2,
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
                VS(16),
              ],
            ),
          ),
        );
      },
    );
  }
}
