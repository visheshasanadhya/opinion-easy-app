import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

/// ── Share Configuration (Edit Here Anytime) ─────────────────────────
const String shareSubject = "Join Daily Opinion — Use My Referral Code";

const String shareMessageTemplate = "🎉 Join Daily Opinion and earn points!\n\n"
    "Use my referral code: {CODE}\n\n"
    "Sign up now and we both earn 100 points when you make your first participation!";

class ReferAndEarnView extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  ReferAndEarnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(title: "Refer & Earn", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Hero Illustration ──────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: AppDeco.card,
              child: Column(
                children: [
                  Image.asset(
                    AppAsset.referEarn,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  VS(20),
                  Text(
                    "Invite Friends & Earn\nDaily Opinion Points",
                    textAlign: TextAlign.center,
                    style: AppText.h2.copyWith(height: 1.3),
                  ),
                  VS(12),
                  Text(
                    "Share your unique referral code with friends. When they make their first participation, you'll both earn 100 points.",
                    textAlign: TextAlign.center,
                    style: AppText.caption,
                  ),
                ],
              ),
            ),
            VS(16),

            // ── Referral Code Box ──────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: AppDeco.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Referral Code", style: AppText.hint),
                  VS(12),
                  Obx(() {
                    final code =
                        profileController.profile.value?.refferalCode ?? "NA";
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.cardAlt,
                        borderRadius: BorderRadius.circular(AppDeco.radius),
                        border: Border.all(color: AppColor.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            code,
                            style: AppText.h1.copyWith(letterSpacing: 4),
                          ),
                          // Copy Button
                          GestureDetector(
                            onTap: () => _copyCode(code),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.cardLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColor.borderLight),
                              ),
                              child: const Icon(
                                Icons.copy_rounded,
                                color: AppColor.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            VS(16),

            // ── Reward Highlight ───────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColor.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppDeco.radius),
                border: Border.all(color: AppColor.green.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, color: AppColor.green),
                  HS(12),
                  const Expanded(
                    child: Text(
                      "You & your friend both earn 100 Points! 🎉",
                      style: TextStyle(
                        color: AppColor.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VS(24),

            // ── Action Buttons ─────────────────────────────
            Obx(() {
              final code =
                  profileController.profile.value?.refferalCode ?? "NA";
              return Row(
                children: [
                  Expanded(
                    child: SecondaryBtnWidget(
                      name: "Share Code",
                      onTap: () => _shareCode(code, context),
                      horizontalPadding: 0,
                    ),
                  ),
                  HS(12),
                  Expanded(
                    child: SecondaryBtnWidget(
                      name: "Copy Code",
                      onTap: () => _copyCode(code),
                      horizontalPadding: 0,
                    ),
                  ),
                ],
              );
            }),
            VS(20),

            // ── How It Works ───────────────────────────────
            Row(
              children: [
                _stepCard(
                  step: "1",
                  icon: Icons.share_rounded,
                  label: "Share Code",
                ),
                HS(12),
                _stepCard(
                  step: "2",
                  icon: Icons.person_add_alt_1_rounded,
                  label: "Friend Joins",
                ),
                HS(12),
                _stepCard(
                  step: "3",
                  icon: Icons.stars_rounded,
                  label: "Both Earn",
                ),
              ],
            ),
            VS(30),
          ],
        ),
      ),
    );
  }

  // ── Share Referral Code ─────────────────────────────────────
  void _shareCode(String code, BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final shareText = shareMessageTemplate.replaceAll("{CODE}", code);
    final shareResult = await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: shareSubject,
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      ),
    );
    if (shareResult.status == ShareResultStatus.success) {
      Get.snackbar(
        "Shared! 🚀",
        "Referral code shared successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ── Copy Code ───────────────────────────────────────────────
  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      "Copied! 🎉",
      "Referral code copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ── Step Card Widget ────────────────────────────────────────
  Widget _stepCard({
    required String step,
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: AppDeco.card,
        child: Column(
          children: [
            Icon(icon, color: AppColor.white, size: 22),
            VS(10),
            Text(label, style: AppText.labelSm),
            VS(3),
            Text("Step $step", style: AppText.captionSm.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
