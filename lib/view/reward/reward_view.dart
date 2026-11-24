import 'package:cached_network_image/cached_network_image.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/controller/reward_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class RewardView extends StatefulWidget {
  const RewardView({super.key});

  @override
  State<RewardView> createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  final RewardController rewardController = Get.put(RewardController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(
        title: "Rewards Store",
        showBackButton: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.white,
          backgroundColor: AppColor.card,
          onRefresh: () async {
            await Future.wait([
              rewardController.fetchRewards(),
              profileController.fetchProfile(),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              // ── Balance card ─────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _buildBalanceCard(),
                ),
              ),

              // ── Section heading ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: AppColor.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text("Available Rewards", style: AppText.h4),
                    ],
                  ),
                ),
              ),

              // ── Grid ────────────────────────────────────
              Obx(() {
                if (rewardController.isLoading.value) return _shimmerGrid();
                final rewards = rewardController.rewards.value?.data ?? [];
                if (rewards.isEmpty) return _emptyState();

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildRewardCard(context, rewards[index]),
                      childCount: rewards.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Balance card ────────────────────────────────────────────

  Widget _buildBalanceCard() {
    return Container(
      decoration: AppDeco.card,
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColor.textGrey,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "YOUR BALANCE",
                      style: AppText.hint.copyWith(
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          "${profileController.profile.value?.points ?? 0}",
                          style: AppText.display,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "pts",
                        style: AppText.body.copyWith(color: AppColor.textGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text("available to redeem", style: AppText.captionSm),
              ],
            ),
          ),
          Container(width: 1, height: 60, color: AppColor.borderFaint),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Monthly\nLimit", style: AppText.captionSm),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.borderLight),
                  ),
                  child: Text(
                    "${rewardController.remainingRedemption.value}",
                    style: AppText.h3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Reward card ─────────────────────────────────────────────

  Widget _buildRewardCard(BuildContext context, dynamic reward) {
    final userPts = profileController.profile.value?.points ?? 0;
    final canAfford = userPts >= (reward.points ?? 0);

    return Container(
      decoration: AppDeco.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDeco.radius - 1),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: reward.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColor.cardAlt),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColor.cardAlt,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColor.textGrey,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                // Points badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: AppColor.black,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "${reward.points}",
                          style: AppText.micro.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reward.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.labelSm,
                  ),
                  Obx(() {
                    final isRedeeming =
                        rewardController.isRedeeming.value == reward.id;
                    return SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: (isRedeeming || !canAfford)
                            ? null
                            : () => _handleRedeem(context, reward),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAfford
                              ? AppColor.white
                              : Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: canAfford
                                  ? AppColor.white
                                  : AppColor.borderLight,
                            ),
                          ),
                        ),
                        child: isRedeeming
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.white,
                                ),
                              )
                            : Text(
                                canAfford ? "Redeem" : "Need more pts",
                                style: AppText.micro.copyWith(
                                  color: canAfford
                                      ? AppColor.black
                                      : AppColor.textGrey,
                                  fontSize: 11,
                                ),
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Redeem dialog ───────────────────────────────────────────

  void _handleRedeem(BuildContext context, dynamic reward) {
    showDialog(
      context: context,
      barrierColor: AppColor.blackOp(0.7),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(AppDeco.radiusLg),
            border: Border.all(color: AppColor.borderLight),
          ),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: AppDeco.circleBorder,
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  size: 32,
                  color: AppColor.white,
                ),
              ),
              const SizedBox(height: 18),
              Text("Redeem Reward", style: AppText.h2),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppText.caption,
                  children: [
                    const TextSpan(text: "Redeeming "),
                    TextSpan(
                      text: reward.name,
                      style: AppText.caption.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: " for "),
                    TextSpan(
                      text: "${reward.points} pts",
                      style: AppText.caption.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderFaint),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColor.textGrey,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Amount will reach your bank within 7 working days",
                        style: AppText.captionSm,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: AppColor.borderLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDeco.radius),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppText.bodyMd.copyWith(
                          color: AppColor.textGrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final ok = await rewardController.redeem(reward.id);
                        if (ok && context.mounted) {
                          Get.snackbar(
                            "Success!",
                            "Redemption request submitted",
                            backgroundColor: AppColor.card,
                            colorText: AppColor.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 14,
                            snackPosition: SnackPosition.TOP,
                          );
                          profileController.fetchProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDeco.radius),
                        ),
                      ),
                      child: Text(
                        "Confirm",
                        style: AppText.bodyMd.copyWith(color: AppColor.black),
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

  // ── Shimmer grid ────────────────────────────────────────────

  Widget _shimmerGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, __) => Shimmer.fromColors(
            baseColor: AppColor.shimmerBase,
            highlightColor: AppColor.shimmerHighlight,
            child: Container(decoration: AppDeco.card),
          ),
          childCount: 6,
        ),
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────

  Widget _emptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDeco.circleBorder,
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: AppColor.white,
              ),
            ),
            const SizedBox(height: 20),
            Text("No rewards available yet", style: AppText.h4),
            const SizedBox(height: 6),
            Text("Check back later!", style: AppText.caption),
          ],
        ),
      ),
    );
  }
}
