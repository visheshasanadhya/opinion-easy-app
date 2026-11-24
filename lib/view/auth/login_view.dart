import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/google_auth_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

class LoginView extends StatelessWidget {
  final GoogleAuthController googleAuthController =
      Get.put(GoogleAuthController());

  LoginView({super.key});

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
                          AppAsset.OpinionEasy_logo,
                          height: 100,
                        ),
                      ),
                      VS(12),
                      Text("Welcome to Opinion Easy", style: AppText.h3),
                      VS(4),
                      Text("Earning Reward and Gift", style: AppText.caption),
                      VS(40),

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
                                        AppAsset.googleLogo,
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
