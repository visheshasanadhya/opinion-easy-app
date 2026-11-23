import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/auth_controller/login_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:pinput/pinput.dart';
import 'package:opinion_easy/controller/auth_controller/google_auth_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());

  LoginView({super.key});

  // ── Shared input decoration ────────────────────────────────
  static InputDecoration _phoneDecoration() {
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

  // ── Pinput theme (dark) ────────────────────────────────────
  static PinTheme get _darkPinTheme => PinTheme(
        width: 60,
        height: 60,
        textStyle: AppText.h3,
        decoration: BoxDecoration(
          color: AppColor.cardLight,
          borderRadius: BorderRadius.circular(AppDeco.radiusSm),
          border: Border.all(color: AppColor.borderMedium),
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
      body: Form(
        key: loginController.loginKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/icons/logo_512.png", height: 100),
              ),
              VS(12),
              Text("Welcome to Opinion Easy", style: AppText.h3),
              VS(4),
              Text("Earning Reward and Gift", style: AppText.caption),
              VS(36),

              // ── Phone label ────────────────────────────
              Align(
                alignment: Alignment.topLeft,
                child: Text("Phone Number", style: AppText.hint),
              ),
              VS(8),

              // ── Phone field ────────────────────────────
              TextFormField(
                controller: loginController.phoneController,
                cursorColor: AppColor.white,
                style: AppText.bodyMd,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: _phoneDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  // if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                  //   return 'Enter a valid mobile number';
                  // }
                  return null;
                },
              ),
              VS(22),

              PrimaryBtnWidget(
                name: "Continue",
                onTap: () {
                  if (loginController.loginKey.currentState!.validate()) {
                    _mpinSheet(context);
                  }
                },
              ),

              // ── OR divider ─────────────────────────────── ADD FROM HERE
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

              // ── Google Sign-In button ──────────────────────
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: googleAuthController.isLoading.value
                        ? null
                        : () async {
                            bool success =
                                await googleAuthController.loginWithGoogle();
                            if (success) {
                              Get.offAllNamed('/bottom-nav');
                            }
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.borderLight),
                      backgroundColor: AppColor.cardAlt,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
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
                              Text(
                                "Continue with Google",
                                style: AppText.bodyMd,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              // ── ADD TILL HERE ──────────────────────────────

              VS(20),

              InkWell(
                onTap: () => Get.offNamed('/register'),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an Account? ",
                        style: AppText.bodyMd,
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: AppText.bodyMd.copyWith(
                          color: AppColor.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _mpinSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColor.card,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(color: AppColor.borderLight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Handle ──────────────────────────
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColor.cardLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text("Enter Your MPIN", style: AppText.h2),
                  VS(8),
                  Text(
                    "Enter 4-digit PIN to access your account",
                    style: AppText.caption,
                  ),
                  VS(28),

                  Pinput(
                    length: 4,
                    controller: loginController.mpinController,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: _darkPinTheme,
                    focusedPinTheme: _focusedPinTheme,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter MPIN';
                      if (value.length != 4) return 'MPIN must be 4 digits';
                      return null;
                    },
                  ),
                  VS(28),

                  Obx(
                    () => PrimaryBtnWidget(
                      name: loginController.isLoading.value
                          ? "Loading..."
                          : "Continue",
                      horizontalPadding: 40,
                      onTap: () async {
                        if (!loginController.loginKey.currentState!.validate())
                          return;

                        final requestData = {
                          'phone': loginController.phoneController.text.trim(),
                          'mpin': loginController.mpinController.text.trim(),
                        };
                        bool isSuccess = await loginController.login(
                          requestData,
                        );
                        if (isSuccess) {
                          Get.back();
                          Get.offAllNamed('/bottom-nav');
                        }
                      },
                    ),
                  ),
                  VS(16),

                  InkWell(
                    onTap: () => Get.toNamed('/forgot'),
                    child: Text(
                      "Forgot MPIN?",
                      style: AppText.captionSm.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  VS(8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
