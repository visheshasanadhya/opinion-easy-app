import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:opinion_easy/core/admob/ad_units.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

// ── Self-Managed Adaptive Banner Ad ──────────────────────────
class AppBannerAd extends StatefulWidget {
  final String? adUnitId;
  final EdgeInsetsGeometry padding;

  const AppBannerAd({
    super.key,
    this.adUnitId,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null && !_isLoading && !kIsWeb) {
      _loadBanner();
    }
  }

  Future<void> _loadBanner() async {
    _isLoading = true;
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (size == null || !mounted) {
      _isLoading = false;
      return;
    }

    final ad = BannerAd(
      adUnitId: widget.adUnitId ?? AdUnits.homeBanner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          setState(() {
            _bannerAd = loadedAd as BannerAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isLoaded = false;
              _isLoading = false;
            });
          }
        },
      ),
    );

    await ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: widget.padding,
      child: Center(
        child: Container(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
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
          child: AdWidget(
            key: ValueKey('banner_${_bannerAd.hashCode}'),
            ad: _bannerAd!,
          ),
        ),
      ),
    );
  }
}

// ── Self-Managed Native Ad ───────────────────────────────────
class AppNativeAd extends StatefulWidget {
  final String? adUnitId;
  final double height;
  final EdgeInsetsGeometry padding;

  const AppNativeAd({
    super.key,
    this.adUnitId,
    this.height = 300,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  State<AppNativeAd> createState() => _AppNativeAdState();
}

class _AppNativeAdState extends State<AppNativeAd> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  static NativeTemplateStyle get _darkNativeStyle => NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: AppColor.cardAlt,
        cornerRadius: 14.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.black,
          backgroundColor: AppColor.white,
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.white,
          backgroundColor: AppColor.cardAlt,
          style: NativeTemplateFontStyle.bold,
          size: 15.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textGrey,
          backgroundColor: AppColor.cardAlt,
          style: NativeTemplateFontStyle.normal,
          size: 13.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textGrey,
          backgroundColor: AppColor.cardAlt,
          style: NativeTemplateFontStyle.normal,
          size: 11.0,
        ),
      );

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadNativeAd();
    }
  }

  void _loadNativeAd() {
    final ad = NativeAd(
      adUnitId: widget.adUnitId ?? AdUnits.questionPageNative,
      request: const AdRequest(),
      nativeTemplateStyle: _darkNativeStyle,
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          setState(() {
            _nativeAd = loadedAd as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (mounted) {
            setState(() {
              _nativeAd = null;
              _isLoaded = false;
            });
          }
        },
      ),
    );

    ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !_isLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: widget.padding,
      child: Container(
        height: widget.height,
        width: double.infinity,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AdWidget(
            key: ValueKey('native_${_nativeAd.hashCode}'),
            ad: _nativeAd!,
          ),
        ),
      ),
    );
  }
}

// ── Backward-Compatibility Aliases ───────────────────────────
class DarkBannerAdWidget extends StatelessWidget {
  final dynamic controller;
  final dynamic isLoaded;
  final dynamic bannerAd;
  final bool showShimmer;
  final double shimmerHeight;
  final String? adUnitId;

  const DarkBannerAdWidget({
    super.key,
    this.controller,
    this.isLoaded,
    this.bannerAd,
    this.showShimmer = false,
    this.shimmerHeight = 50,
    this.adUnitId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBannerAd(adUnitId: adUnitId);
  }
}

class DarkNativeAdWidget extends StatelessWidget {
  final dynamic controller;
  final dynamic isLoaded;
  final dynamic nativeAd;
  final double height;
  final bool showShimmer;
  final String? adUnitId;

  const DarkNativeAdWidget({
    super.key,
    this.controller,
    this.isLoaded,
    this.nativeAd,
    this.height = 300,
    this.showShimmer = false,
    this.adUnitId,
  });

  @override
  Widget build(BuildContext context) {
    return AppNativeAd(
      height: height,
      adUnitId: adUnitId,
    );
  }
}
