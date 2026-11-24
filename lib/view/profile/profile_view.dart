import 'package:flutter/services.dart';
import 'package:opinion_easy/controller/history_controller.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/view/profile/profile_content/refer_and_earn.dart';
import 'package:share_plus/share_plus.dart';

class ProfileView extends StatelessWidget {
  final ProfileController profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
  final HistoryController historyController =
      Get.isRegistered<HistoryController>()
          ? Get.find<HistoryController>()
          : Get.put(HistoryController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(
        title: "Profile",
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          children: [
            _buildProfileCard(),
            VS(22),
            _section("Account Settings", [
              _referItem(),
              _item(Icons.history_rounded, "History", () {
                historyController.fetchHistory();
                Get.toNamed('/history');
              }),
              _item(
                Icons.account_balance_outlined,
                "Bank Details",
                () => Get.toNamed('/bank'),
              ),
            ]),
            VS(22),
            _section("Leaderboard", [
              _item(
                Icons.emoji_events_outlined,
                "Top Monthly Earners",
                () => Get.toNamed('/monthly-top-performer'),
              ),
            ]),
            VS(22),
            _section("Support & Legal", [
              _item(
                Icons.info_outline_rounded,
                "About Us",
                () => Get.toNamed('/about-us'),
              ),
              _item(
                Icons.help_outline_rounded,
                "FAQ",
                () => Get.toNamed('/faq-view'),
              ),
              _item(
                Icons.support_agent_rounded,
                "Help & Support",
                () => Get.toNamed('/help'),
              ),
              _item(
                Icons.privacy_tip_outlined,
                "Privacy Policy",
                () => Get.toNamed('/privacy-policy'),
              ),
              _item(
                Icons.description_outlined,
                "Terms & Conditions",
                () => Get.toNamed('/terms-and-conditions'),
              ),
            ]),
            VS(28),
            // ── Logout button using SecondaryBtnWidget ──────────
            PrimaryBtnWidget(
              name: "Logout",
              onTap: () => _showLogoutDialog(context),
            ),
            VS(24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return InkWell(
      onTap: () {
        if (profileController.profile.value != null)
          profileController.setProfileData(profileController.profile.value!);
        Get.toNamed('/edit-profile');
      },
      borderRadius: BorderRadius.circular(AppDeco.radius),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppDeco.card,
        child: Row(
          children: [
            Obx(() {
              final profile = profileController.profile.value;
              final hasImage = profile?.profilePic != null &&
                  profile!.profilePic!.isNotEmpty;
              return Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.cardAlt,
                  border: Border.all(color: AppColor.borderLight, width: 1.5),
                  image: hasImage
                      ? DecorationImage(
                          image: NetworkImage(profile.profilePic!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !hasImage
                    ? const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColor.textGrey,
                      )
                    : null,
              );
            }),
            HS(14),
            Expanded(
              child: Obx(() {
                final profile = profileController.profile.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name ?? "User",
                      style: AppText.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    VS(3),
                    Text(
                      profile?.email ?? "",
                      style: AppText.captionSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }),
            ),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.borderStrong),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColor.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title, style: AppText.hint),
        ),
        Material(
          color: AppColor.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDeco.radius),
            side: const BorderSide(color: AppColor.borderFaint),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items
                .asMap()
                .entries
                .map(
                  (e) => Column(
                    children: [
                      e.value,
                      if (e.key != items.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColor.borderFaint,
                          indent: 54,
                        ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  /// ── Refer & Earn item with inline referral code + copy/share icons ──
  Widget _referItem() {
    return ListTile(
      onTap: () => Get.toNamed('/refer-earn'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.borderLight),
        ),
        child: const Icon(
          Icons.ios_share_rounded,
          color: AppColor.textGrey,
          size: 18,
        ),
      ),
      title: Text("Refer & Earn", style: AppText.bodyMd),
      subtitle: Obx(() {
        final code = profileController.profile.value?.refferalCode;
        if (code == null || code.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              // Referral code pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.cardAlt,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColor.borderStrong),
                ),
                child: Text(
                  code,
                  style: AppText.label.copyWith(
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              HS(20),
              // Copy icon button
              GestureDetector(
                onTap: () => _copyCode(code),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColor.borderLight),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 20,
                    color: AppColor.borderStrong,
                  ),
                ),
              ),
              HS(12),
              // Share icon button
              GestureDetector(
                onTap: () => _shareCode(code),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColor.borderLight),
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    size: 20,
                    color: AppColor.borderStrong,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13,
        color: AppColor.textGrey,
      ),
    );
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      "Copied! 🎉",
      "Referral code copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _shareCode(String code) {
    final shareText = shareMessageTemplate.replaceAll("{CODE}", code);
    SharePlus.instance.share(
      ShareParams(text: shareText, subject: shareSubject),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.borderLight),
        ),
        child: Icon(icon, color: AppColor.textGrey, size: 18),
      ),
      title: Text(title, style: AppText.bodyMd),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13,
        color: AppColor.textGrey,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: AppColor.blackOp(0.65),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(AppDeco.radiusLg),
            border: Border.all(color: AppColor.borderLight),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppDeco.circleBorder,
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColor.white,
                  size: 28,
                ),
              ),
              VS(16),
              Text("Logout?", style: AppText.h1),
              VS(8),
              Text(
                "Are you sure you want to logout from your account?",
                textAlign: TextAlign.center,
                style: AppText.caption,
              ),
              VS(22),
              Row(
                children: [
                  Expanded(
                    child: SecondaryBtnWidget(
                      name: "Cancel",
                      onTap: () => Get.back(),
                      horizontalPadding: 0,
                    ),
                  ),
                  HS(12),
                  Expanded(
                    child: Obx(
                      () => PrimaryBtnWidget(
                        name: profileController.isLoading.value
                            ? "..."
                            : "Logout",
                        onTap: () async => await profileController.logout(),
                        horizontalPadding: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
