import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/auth_controller/google_auth_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

class LoginView extends StatelessWidget {
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());

  LoginView({super.key});

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppText.captionSm,
      filled: true,
      fillColor: AppColor.cardAlt,
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Icon(
          Icons.card_giftcard_outlined,
          color: AppColor.white,
          size: 20,
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
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppText.hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // ── App Logo & Header ───────────────────
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
                      VS(36),

                      // ── Referral Code (Optional) ────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _label("Referral Code"),
                      ),
                      TextFormField(
                        controller: googleAuthController.referralController,
                        cursorColor: AppColor.white,
                        style: AppText.bodyMd,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _fieldDecoration(
                          "Enter Referral Code (optional)",
                        ),
                      ),
                      VS(8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter friend's code to get 500 bonus points on signup.",
                          style: AppText.captionSm.copyWith(
                            color: AppColor.textGrey,
                          ),
                        ),
                      ),

                      VS(28),

                      // ── Sign In with Google Button ──────────
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: googleAuthController.isLoading.value
                                ? null
                                : () => googleAuthController.loginWithGoogle(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.white,
                              foregroundColor: AppColor.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDeco.radiusSm),
                              ),
                            ),
                            child: googleAuthController.isLoading.value
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: AppColor.black,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/google_logo.png',
                                        height: 22,
                                        width: 22,
                                      ),
                                      HS(12),
                                      Text(
                                        "Sign In with Google",
                                        style: AppText.bodyMd.copyWith(
                                          color: AppColor.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // ── Terms and Conditions ────────────────
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
                      VS(24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
