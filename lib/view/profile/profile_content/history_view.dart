import 'package:opinion_easy/controller/history_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryController historyController =
      Get.isRegistered<HistoryController>()
          ? Get.find<HistoryController>()
          : Get.put(HistoryController());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        historyController.loadMore();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: CustomAppBar(title: "Activity History"),
      body: SafeArea(
        child: Obx(() {
          if (historyController.isLoading.value &&
              historyController.history.isEmpty &&
              historyController.redeemHistory.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor1),
            );
          }

          if (historyController.history.isEmpty &&
              historyController.redeemHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_edu_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No transaction history",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColor.primaryColor1,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await historyController.fetchHistory(isRefresh: true);
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // 🟢 Section 1: Answers History
                if (historyController.history.isNotEmpty) ...[
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "Answers History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final history = historyController.history[index];
                      return _buildAnswerHistoryCard(history);
                    }, childCount: historyController.history.length),
                  ),
                ],

                // 🟣 Section 2: Redeem History
                if (historyController.redeemHistory.isNotEmpty) ...[
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "Redeem History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final redeem = historyController.redeemHistory[index];
                      return _buildRedeemHistoryCard(redeem);
                    }, childCount: historyController.redeemHistory.length),
                  ),
                ],

                // Loader
                if (historyController.isMoreLoading.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryColor1,
                        ),
                      ),
                    ),
                  ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAnswerHistoryCard(dynamic history) {
    bool isWin = history.points.toString() != "0";
    bool isDismissed = history.status == "Dismissed";
    bool isPending = history.isPending ?? false;

    // Determine status color and text
    Color statusColor;
    String statusText;

    if (isPending) {
      statusColor = Colors.grey;
      statusText = "PENDING";
    } else if (isDismissed) {
      statusColor = Colors.orange;
      statusText = "REFUNDED";
    } else if (isWin) {
      statusColor = Colors.green;
      statusText = "WON";
    } else {
      statusColor = Colors.red;
      statusText = "LOST";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF2D8FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  history.category ?? "General",
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            history.question ?? "No question",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Answer",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      history.answer ?? "N/A",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Points
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (history.points ?? 0) > 0
                          ? "+${history.points}"
                          : isDismissed
                              ? "+${history.attemptPoint}" // Refund
                              : "-${history.attemptPoint}", // Cost
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: (history.points ?? 0) > 0 || isDismissed
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Text(
                      "Pts",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemHistoryCard(dynamic redeem) {
    // Status color logic
    Color statusColor;
    switch (redeem.status?.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.card_giftcard, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  redeem.rewardName ?? "Reward Redemption",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (redeem.status ?? "Pending").toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (redeem.remarks != null && redeem.remarks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      redeem.remarks,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${redeem.points}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Pts",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
