import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_shimmer.dart';

// ── Native Ad Widget ─────────────────────────────────────────
class DarkNativeAdWidget extends StatelessWidget {
  final RxBool isLoaded;
  final NativeAd? nativeAd;
  final double height;
  final bool showShimmer;

  const DarkNativeAdWidget({
    super.key,
    required this.isLoaded,
    required this.nativeAd,
    this.height = 320,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loaded = isLoaded.value && nativeAd != null;

      if (loaded) {
        return _DarkAdCard(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AdWidget(
              ad: nativeAd!,
              key: ValueKey('native_${nativeAd.hashCode}'),
            ),
          ),
        );
      }

      return showShimmer
          ? AppShimmer.nativeAdPlaceholder(height: height)
          : SizedBox(height: height);
    });
  }
}

// ── Adaptive Banner Widget ───────────────────────────────────
class DarkBannerAdWidget extends StatelessWidget {
  final RxBool isLoaded;
  final BannerAd? bannerAd;
  final bool showShimmer;
  final double shimmerHeight;

  const DarkBannerAdWidget({
    super.key,
    required this.isLoaded,
    required this.bannerAd,
    this.showShimmer = false,
    this.shimmerHeight = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoaded.value && bannerAd != null) {
        return Center(
          child: Container(
            width: bannerAd!.size.width.toDouble(),
            height: bannerAd!.size.height.toDouble(),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.card,
              border: Border(
                top: BorderSide(
                  color: AppColor.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
            ),
            child: AdWidget(ad: bannerAd!),
          ),
        );
      }

      if (showShimmer) {
        return AppShimmer.box(height: shimmerHeight, radius: 8);
      }

      return const SizedBox.shrink();
    });
  }
}

// ── Medium Rectangle Widget (300×250) ────────────────────────
class DarkRectangleAdWidget extends StatelessWidget {
  final RxBool isLoaded;
  final BannerAd? rectangleAd;
  final bool showShimmer;

  const DarkRectangleAdWidget({
    super.key,
    required this.isLoaded,
    required this.rectangleAd,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoaded.value && rectangleAd != null) {
        return Center(
          child: _DarkAdCard(
            height: 250,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AdWidget(ad: rectangleAd!),
            ),
          ),
        );
      }

      return showShimmer
          ? AppShimmer.nativeAdPlaceholder(height: 250)
          : const SizedBox.shrink();
    });
  }
}

// ── Shared Dark Container ────────────────────────────────────
class _DarkAdCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;

  const _DarkAdCard({
    required this.child,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: AppColor.cardAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.borderFaint,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
