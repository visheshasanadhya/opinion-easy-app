import 'package:opinion_easy/controller/history_controller.dart';
import 'package:opinion_easy/controller/nav_controller.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/app_refresh.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/data/model/history_model.dart';
import '../../core/utils/widgets/spacing_widget.dart';

class WalletView extends StatelessWidget {
  final HistoryController historyController = Get.put(HistoryController());
  final BottomNavController bottomNavController =
      Get.find<BottomNavController>();
  final ProfileController profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  WalletView({super.key});

  final ScrollController _scrollController = ScrollController();
  static const int pointsToRupee = 100;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        historyController.loadMore();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(
        title: "My Wallet",
        showBackButton: false,
      ),
      body: Obx(() {
        final loading = historyController.isLoading.value;
        final noData = historyController.history.isEmpty &&
            historyController.redeemHistory.isEmpty;

        if (loading && noData) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.white,
              strokeWidth: 2,
            ),
          );
        }

        return AppRefresh(
          onRefresh: () async {
            await historyController.fetchHistory(isRefresh: true);
            await profileController.fetchProfile();
          },
          child: noData ? _buildEmptyState() : _buildContent(),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildWalletCard(),
              VS(16),
              _buildBoostBanner(),
            ],
          ),
        ),
        VS(80),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDeco.circleBorder,
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 40,
                color: AppColor.white,
              ),
            ),
            VS(16),
            Text("No transactions yet", style: AppText.h4),
            VS(6),
            Text("Start earning points today!", style: AppText.caption),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                _buildWalletCard(),
                VS(16),
                _buildBoostBanner(),
              ],
            ),
          ),
        ),
        if (historyController.redeemHistory.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
            sliver: SliverToBoxAdapter(
              child: _sectionHeader("Redeem Requests"),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: _buildRedeemItem(historyController.redeemHistory[index]),
              ),
              childCount: historyController.redeemHistory.length,
            ),
          ),
        ],
        if (historyController.history.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
            sliver: SliverToBoxAdapter(
              child: _sectionHeader("Earning History"),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: _buildHistoryItem(historyController.history[index]),
              ),
              childCount: historyController.history.length,
            ),
          ),
        ],
        if (historyController.isMoreLoading.value)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColor.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: VS(30)),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        HS(10),
        Text(title, style: AppText.h4),
      ],
    );
  }

  // ── Boost Earnings Banner ────────────────────────────────────────────
  Widget _buildBoostBanner() {
    return GestureDetector(
      onTap: () => Get.toNamed('/refer-earn'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.orange.withOpacity(0.10),
          borderRadius: BorderRadius.circular(AppDeco.radius),
          border: Border.all(color: AppColor.orange.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BOOST EARNINGS",
                    style: AppText.hint.copyWith(
                      color: AppColor.orange,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  VS(4),
                  Text(
                    "Refer & Earn 500 Pts per friend",
                    style: AppText.bodyMd.copyWith(color: AppColor.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.orange.withOpacity(0.35)),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColor.orange,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Wallet Card ──────────────────────────────────────────────────────
  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      decoration: AppDeco.card,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColor.textGrey,
                    size: 14,
                  ),
                  HS(6),
                  Text(
                    "TOTAL POINTS",
                    style: AppText.hint.copyWith(
                      fontSize: 10,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
              Text(
                "VALUE (INR)",
                style: AppText.hint.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          VS(12),

          // Points + Value row
          Obx(() {
            final points = profileController.profile.value?.points ?? 0;
            final rupee = (points / pointsToRupee).toStringAsFixed(2);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // Points side
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$points",
                            style: AppText.display.copyWith(fontSize: 32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                HS(12),
                // INR Value side
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "₹$rupee",
                    style: AppText.display.copyWith(fontSize: 32),
                  ),
                ),
              ],
            );
          }),

          VS(6),
          Text(
            "* $pointsToRupee Points = ₹1.00  •  Min Withdrawal ₹100",
            style: AppText.captionSm.copyWith(
              color: AppColor.textGrey,
              fontSize: 11,
            ),
          ),

          VS(16),
          // ── Two buttons: Withdraw + Redeem Gifts ──────────────
          Row(
            children: [
              Expanded(
                child: PrimaryBtnWidget(
                  name: "Withdraw",
                  onTap: () => bottomNavController.changeIndex(2),
                  horizontalPadding: 0,
                ),
              ),
              HS(12),
              Expanded(
                child: SecondaryBtnWidget(
                  name: "Redeem Gifts",
                  onTap: () => bottomNavController.changeIndex(2),
                  // onTap: () => Get.toNamed('/redeem'),
                  horizontalPadding: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(HistoryModel history) {
    final bool isDismissed = history.status == "Dismissed";
    final bool isCredit = (history.points ?? 0) > 0;
    final String amount = isDismissed
        ? "+${history.attemptPoint}"
        : (isCredit ? "+${history.points}" : "-${history.attemptPoint}");

    return Container(
      decoration: AppDeco.card,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: AppDeco.circleBorder,
            child: Icon(
              (isCredit || isDismissed)
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: AppColor.white,
              size: 18,
            ),
          ),
          HS(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        history.category ?? "Unknown",
                        style: AppText.bodyMd,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    HS(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(amount, style: AppText.points),
                        Text(
                          "pts",
                          style: AppText.captionSm.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                VS(6),
                Text(
                  history.question ?? "",
                  style: AppText.captionSm,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                VS(10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.borderLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("YOUR ANSWER", style: AppText.micro),
                      ),
                      HS(8),
                      Flexible(
                        child: Text(
                          history.answer ?? "NA",
                          style: AppText.labelSm,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemItem(RedeemModel redeem) {
    final statusColor = _statusColor(redeem.status);
    final rupee = ((redeem.points ?? 0) / pointsToRupee).toStringAsFixed(2);

    return Container(
      decoration: AppDeco.card,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: AppDeco.squareBorder,
            child: const Icon(
              Icons.redeem_rounded,
              color: AppColor.white,
              size: 22,
            ),
          ),
          HS(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  redeem.rewardName ?? "Redemption",
                  style: AppText.bodyMd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                VS(6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "₹$rupee",
                        style: AppText.micro.copyWith(fontSize: 12),
                      ),
                    ),
                    HS(8),
                    Text("${redeem.points} pts", style: AppText.captionSm),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Text(
              (redeem.status ?? "PENDING").toUpperCase(),
              style: AppText.micro.copyWith(color: statusColor, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "approved":
        return AppColor.green;
      case "rejected":
        return AppColor.red;
      default:
        return AppColor.orange;
    }
  }
}
