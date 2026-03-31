import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

/// ============================================================
/// AppShimmer
/// A collection of reusable shimmer widgets for the app.
///
/// Usage examples:
///   AppShimmer.box(height: 200, radius: 24)
///   AppShimmer.circle(size: 50)
///   AppShimmer.line(width: 120)
///   AppShimmer.banner()
///   AppShimmer.categoryCard()
///   AppShimmer.categoryList()
///   AppShimmer.subCategoryList()
///   AppShimmer.questionCard()
///   AppShimmer.nativeAdPlaceholder()
///   AppShimmer.notificationItem()
///   AppShimmer.notificationList()
/// ============================================================
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  // ── Core wrapper ───────────────────────────────────────────

  /// Wraps any [child] widget with the standard app shimmer effect.
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: child,
    );
  }

  // ══════════════════════════════════════════════════════════
  // PRIMITIVE SHAPES
  // ══════════════════════════════════════════════════════════

  /// A generic shimmering rounded box.
  static Widget box({
    required double height,
    double? width,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  /// A shimmering circle — useful for avatars / icons.
  static Widget circle({required double size}) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColor.shimmerBase,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// A short shimmering line — useful for text placeholders.
  static Widget line({double? width, double height = 14, double radius = 6}) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // COMPOSITE COMPONENTS
  // ══════════════════════════════════════════════════════════

  /// Full-width banner shimmer — used in HomeView carousel placeholder.
  static Widget banner({double height = 200}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: box(height: height, radius: 24),
    );
  }

  /// Single category card shimmer row.
  static Widget categoryCard() {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// Vertical list of [count] category card shimmers.
  static Widget categoryList({int count = 5}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          count,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: categoryCard(),
          ),
        ),
      ),
    );
  }

  /// Single sub-category card shimmer.
  static Widget subCategoryCard() {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Scrollable list of [count] sub-category shimmers.
  static Widget subCategoryList({int count = 8}) {
    return ListView.separated(
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => subCategoryCard(),
    );
  }

  /// Question screen shimmer — question card + two buttons + native ad slot.
  static Widget questionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
      child: Column(
        children: [
          box(height: 180, radius: 20),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: box(height: 52, radius: 14)),
              const SizedBox(width: 14),
              Expanded(child: box(height: 52, radius: 14)),
            ],
          ),
          const SizedBox(height: 20),
          box(height: 300, radius: 16),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  /// Native ad loading placeholder (300 px tall).
  static Widget nativeAdPlaceholder({double height = 300}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.cardAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderFaint),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColor.textDisabled,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Loading ad...",
            style: TextStyle(color: AppColor.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Single notification item shimmer.
  static Widget notificationItem() {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.cardLight,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.cardLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColor.cardLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColor.cardLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vertical list of [count] notification item shimmers.
  static Widget notificationList({int count = 6}) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => notificationItem(),
    );
  }
}
