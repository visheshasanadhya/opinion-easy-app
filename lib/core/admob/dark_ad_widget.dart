import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ── Native ad (TemplateType.medium ~300 px) ────────────────────────────────
class DarkNativeAdWidget extends StatelessWidget {
  final RxBool isLoaded;
  final NativeAd? nativeAd;
  final double height;
  final bool showShimmer;

  const DarkNativeAdWidget({
    super.key,
    required this.isLoaded,
    required this.nativeAd,
    this.height = 300,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoaded.value && nativeAd != null) {
        return _DarkAdCard(
          height: height,
          child: AdWidget(
            ad: nativeAd!,
            key: ValueKey('native_${nativeAd.hashCode}'),
          ),
        );
      }
      return showShimmer
          ? AppShimmer.nativeAdPlaceholder(height: height)
          : SizedBox(height: height); // keep layout space, no flicker
    });
  }
}

// ── Adaptive banner / dialog banner ───────────────────────────────────────
class DarkBannerAdWidget extends StatelessWidget {
  final RxBool isLoaded;
  final BannerAd? bannerAd;

  /// Whether to show a shimmer while the ad is loading.
  /// Set to false for dialog banners (they have their own timeout logic).
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
        return Container(
          // Exact ad size so there's no dead space around the creative.
          width: bannerAd!.size.width.toDouble(),
          height: bannerAd!.size.height.toDouble(),
          // Dark strip behind the banner creative.
          // The creative itself is served by Google so we can't recolour it,
          // but at least the surrounding chrome matches the dark theme.
          decoration: BoxDecoration(
            color: AppColor.card,
            border: Border(
              top: BorderSide(
                color: AppColor.white.withOpacity(0.06),
                width: 1,
              ),
            ),
          ),
          child: AdWidget(ad: bannerAd!),
        );
      }
      if (showShimmer) {
        return AppShimmer.box(height: shimmerHeight, radius: 8);
      }
      return const SizedBox.shrink();
    });
  }
}

// ── Medium rectangle 300×250 ──────────────────────────────────────────────
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
        return _DarkAdCard(
          height: 250,
          width: 300,
          child: AdWidget(ad: rectangleAd!),
        );
      }
      return showShimmer
          ? AppShimmer.nativeAdPlaceholder(height: 250)
          : const SizedBox.shrink();
    });
  }
}

// ── Internal: shared dark card container ──────────────────────────────────
// This is the Flutter-side wrapper that makes the ad slot look native to
// the dark theme. The actual ad creative inside it is Google-controlled.
class _DarkAdCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;

  const _DarkAdCard({required this.child, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        // Matches NativeTemplateStyle.mainBackgroundColor in admob.dart.
        // Both must be the same colour or you'll see a flash on ad load.
        color: AppColor.cardAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.borderFaint, // white @ 8 %
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}
