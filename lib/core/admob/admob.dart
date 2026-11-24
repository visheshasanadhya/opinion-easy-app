import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:opinion_easy/core/admob/ad_units.dart';
import '../utils/app_constants.dart';

/// Enterprise AdsController managing lifecycle, smart exponential retries,
/// dark native templates, and high-eCPM configuration.
class AdsController extends GetxController {
  // ── Adaptive Banner ──────────────────────────────────────────
  BannerAd? bannerAd;
  final RxBool isLoaded = false.obs;
  int _bannerRetryCount = 0;
  Timer? _bannerRetryTimer;

  // ── Native Ad ────────────────────────────────────────────────
  NativeAd? nativeAd;
  final RxBool isNativeLoaded = false.obs;
  int _nativeRetryCount = 0;
  Timer? _nativeRetryTimer;

  // ── Medium Rectangle (300×250) ──────────────────────────────
  BannerAd? rectangleAd;
  final RxBool isRectangleLoaded = false.obs;
  int _rectangleRetryCount = 0;
  Timer? _rectangleRetryTimer;

  // ── Interstitial Ad ──────────────────────────────────────────
  InterstitialAd? interstitialAd;
  final RxBool isInterstitialLoaded = false.obs;
  final RxBool isInterstitialLoading = false.obs;
  int _interstitialRetryCount = 0;
  Timer? _interstitialRetryTimer;

  // ── Rewarded Ad ──────────────────────────────────────────────
  RewardedAd? rewardedAd;
  final RxBool isRewardedLoaded = false.obs;
  final RxBool isRewardedLoading = false.obs;
  int _rewardedRetryCount = 0;
  Timer? _rewardedRetryTimer;

  // ── Rewarded Interstitial ────────────────────────────────────
  RewardedInterstitialAd? rewardedInterstitialAd;
  final RxBool isRewardedInterstitialLoaded = false.obs;
  final RxBool isRewardedInterstitialLoading = false.obs;

  // ── App Open Ad ──────────────────────────────────────────────
  AppOpenAd? appOpenAd;
  final RxBool isAppOpenLoaded = false.obs;
  final RxBool isAppOpenLoading = false.obs;
  int _appOpenRetryCount = 0;
  Timer? _appOpenRetryTimer;

  static const int _maxRetries = 3;

  /// High-eCPM targeting configuration
  static AdRequest get _standardAdRequest => const AdRequest(
        httpTimeoutMillis: 10000,
      );

  // ══════════════════════════════════════════════════════════════
  // DARK NATIVE TEMPLATE STYLE
  // ══════════════════════════════════════════════════════════════
  static NativeTemplateStyle get darkNativeStyle => NativeTemplateStyle(
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

  // ══════════════════════════════════════════════════════════════
  // ADAPTIVE BANNER
  // ══════════════════════════════════════════════════════════════

  Future<void> loadAdaptiveBanner(
    BuildContext context, {
    String? adUnitId,
  }) async {
    final unitId = adUnitId ?? AdUnits.homeBanner;
    _bannerRetryTimer?.cancel();

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      debugPrint('⚠️ [AdMob] Unable to calculate adaptive banner size');
      return;
    }

    // Dispose old banner if any
    await bannerAd?.dispose();
    bannerAd = null;
    isLoaded.value = false;

    bannerAd = BannerAd(
      adUnitId: unitId,
      size: size,
      request: _standardAdRequest,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isLoaded.value = true;
          _bannerRetryCount = 0;
          debugPrint('✅ [AdMob] Banner loaded successfully ($unitId)');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ [AdMob] Banner failed to load: ${error.message}');
          ad.dispose();
          bannerAd = null;
          isLoaded.value = false;

          if (_bannerRetryCount < _maxRetries) {
            _bannerRetryCount++;
            final delay = Duration(seconds: 1 << _bannerRetryCount);
            debugPrint('🔄 [AdMob] Retrying banner in ${delay.inSeconds}s (attempt $_bannerRetryCount)');
            _bannerRetryTimer = Timer(delay, () {
              if (context.mounted) {
                loadAdaptiveBanner(context, adUnitId: unitId);
              }
            });
          }
        },
        onAdImpression: (_) => debugPrint('👁️ [AdMob] Banner impression registered'),
        onAdClicked: (_) => debugPrint('🖱️ [AdMob] Banner clicked'),
      ),
    );

    await bannerAd!.load();
  }

  void disposeBanner() {
    _bannerRetryTimer?.cancel();
    bannerAd?.dispose();
    bannerAd = null;
    isLoaded.value = false;
    _bannerRetryCount = 0;
  }

  // ══════════════════════════════════════════════════════════════
  // MEDIUM RECTANGLE (300×250)
  // ══════════════════════════════════════════════════════════════

  void loadRectangleAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.resultRectangle;
    _rectangleRetryTimer?.cancel();

    rectangleAd?.dispose();
    rectangleAd = null;
    isRectangleLoaded.value = false;

    rectangleAd = BannerAd(
      adUnitId: unitId,
      size: AdSize.mediumRectangle,
      request: _standardAdRequest,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isRectangleLoaded.value = true;
          _rectangleRetryCount = 0;
          debugPrint('✅ [AdMob] Rectangle ad loaded ($unitId)');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ [AdMob] Rectangle failed: ${error.message}');
          ad.dispose();
          rectangleAd = null;
          isRectangleLoaded.value = false;

          if (_rectangleRetryCount < _maxRetries) {
            _rectangleRetryCount++;
            final delay = Duration(seconds: 1 << _rectangleRetryCount);
            _rectangleRetryTimer = Timer(delay, () => loadRectangleAd(adUnitId: unitId));
          }
        },
        onAdImpression: (_) => debugPrint('👁️ [AdMob] Rectangle impression'),
        onAdClicked: (_) => debugPrint('🖱️ [AdMob] Rectangle clicked'),
      ),
    )..load();
  }

  void disposeRectangle() {
    _rectangleRetryTimer?.cancel();
    rectangleAd?.dispose();
    rectangleAd = null;
    isRectangleLoaded.value = false;
    _rectangleRetryCount = 0;
  }

  // ══════════════════════════════════════════════════════════════
  // NATIVE ADS (Dark-themed template)
  // ══════════════════════════════════════════════════════════════

  void loadNativeAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.questionPageNative;
    if (isNativeLoaded.value && nativeAd != null) return;

    _nativeRetryTimer?.cancel();
    nativeAd?.dispose();
    nativeAd = null;
    isNativeLoaded.value = false;

    nativeAd = NativeAd(
      adUnitId: unitId,
      request: _standardAdRequest,
      nativeTemplateStyle: darkNativeStyle,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          isNativeLoaded.value = true;
          _nativeRetryCount = 0;
          debugPrint('✅ [AdMob] Native ad loaded successfully ($unitId)');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ [AdMob] Native failed to load: ${error.message}');
          ad.dispose();
          nativeAd = null;
          isNativeLoaded.value = false;

          if (_nativeRetryCount < _maxRetries) {
            _nativeRetryCount++;
            final delay = Duration(seconds: 1 << _nativeRetryCount);
            debugPrint('🔄 [AdMob] Retrying native ad in ${delay.inSeconds}s (attempt $_nativeRetryCount)');
            _nativeRetryTimer = Timer(delay, () => loadNativeAd(adUnitId: unitId));
          }
        },
        onAdImpression: (_) => debugPrint('👁️ [AdMob] Native impression registered'),
        onAdClicked: (_) => debugPrint('🖱️ [AdMob] Native clicked'),
      ),
    );

    nativeAd!.load();
  }

  void disposeNative() {
    _nativeRetryTimer?.cancel();
    nativeAd?.dispose();
    nativeAd = null;
    isNativeLoaded.value = false;
    _nativeRetryCount = 0;
  }

  // ══════════════════════════════════════════════════════════════
  // INTERSTITIAL ADS
  // ══════════════════════════════════════════════════════════════

  void loadInterstitialAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.questionInterstitial;
    if (isInterstitialLoading.value || isInterstitialLoaded.value) return;

    _interstitialRetryTimer?.cancel();
    isInterstitialLoading.value = true;

    InterstitialAd.load(
      adUnitId: unitId,
      request: _standardAdRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ [AdMob] Interstitial loaded successfully ($unitId)');
          interstitialAd = ad;
          isInterstitialLoaded.value = true;
          isInterstitialLoading.value = false;
          _interstitialRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ [AdMob] Interstitial failed: ${error.message}');
          isInterstitialLoading.value = false;
          isInterstitialLoaded.value = false;
          interstitialAd = null;

          if (_interstitialRetryCount < _maxRetries) {
            _interstitialRetryCount++;
            final delay = Duration(seconds: 1 << _interstitialRetryCount);
            _interstitialRetryTimer =
                Timer(delay, () => loadInterstitialAd(adUnitId: unitId));
          }
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (interstitialAd == null || !isInterstitialLoaded.value) {
      debugPrint('ℹ️ [AdMob] Interstitial not ready — continuing flow');
      onAdDismissed?.call();
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) =>
          debugPrint('📺 [AdMob] Interstitial displayed'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('🔙 [AdMob] Interstitial dismissed');
        ad.dispose();
        interstitialAd = null;
        isInterstitialLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('⚠️ [AdMob] Interstitial failed to show: ${error.message}');
        ad.dispose();
        interstitialAd = null;
        isInterstitialLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdImpression: (_) =>
          debugPrint('👁️ [AdMob] Interstitial impression registered'),
    );

    interstitialAd!.show();
  }

  void disposeInterstitial() {
    _interstitialRetryTimer?.cancel();
    interstitialAd?.dispose();
    interstitialAd = null;
    isInterstitialLoaded.value = false;
    isInterstitialLoading.value = false;
    _interstitialRetryCount = 0;
  }

  // ══════════════════════════════════════════════════════════════
  // REWARDED ADS
  // ══════════════════════════════════════════════════════════

  void loadRewardedAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.rewardedCoins;
    if (isRewardedLoading.value || isRewardedLoaded.value) return;

    _rewardedRetryTimer?.cancel();
    isRewardedLoading.value = true;

    RewardedAd.load(
      adUnitId: unitId,
      request: _standardAdRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ [AdMob] Rewarded ad loaded ($unitId)');
          rewardedAd = ad;
          isRewardedLoaded.value = true;
          isRewardedLoading.value = false;
          _rewardedRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ [AdMob] Rewarded ad failed: ${error.message}');
          isRewardedLoading.value = false;
          isRewardedLoaded.value = false;
          rewardedAd = null;

          if (_rewardedRetryCount < _maxRetries) {
            _rewardedRetryCount++;
            final delay = Duration(seconds: 1 << _rewardedRetryCount);
            _rewardedRetryTimer =
                Timer(delay, () => loadRewardedAd(adUnitId: unitId));
          }
        },
      ),
    );
  }

  void showRewardedAd({
    required void Function(AdWithoutView ad, RewardItem reward)
        onUserEarnedReward,
    VoidCallback? onAdDismissed,
  }) {
    if (rewardedAd == null || !isRewardedLoaded.value) {
      debugPrint('ℹ️ [AdMob] Rewarded ad not ready');
      onAdDismissed?.call();
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) =>
          debugPrint('📺 [AdMob] Rewarded ad displayed'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('🔙 [AdMob] Rewarded ad dismissed');
        ad.dispose();
        rewardedAd = null;
        isRewardedLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('⚠️ [AdMob] Rewarded ad failed to show: ${error.message}');
        ad.dispose();
        rewardedAd = null;
        isRewardedLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdImpression: (_) =>
          debugPrint('👁️ [AdMob] Rewarded ad impression registered'),
    );

    rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🎁 [AdMob] Reward granted: ${reward.amount} ${reward.type}');
        onUserEarnedReward(ad, reward);
      },
    );
  }

  void disposeRewarded() {
    _rewardedRetryTimer?.cancel();
    rewardedAd?.dispose();
    rewardedAd = null;
    isRewardedLoaded.value = false;
    isRewardedLoading.value = false;
    _rewardedRetryCount = 0;
  }

  // ══════════════════════════════════════════════════════════════
  // REWARDED INTERSTITIAL ADS
  // ══════════════════════════════════════════════════════════════

  void loadRewardedInterstitialAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.rewardedInterstitial;
    if (isRewardedInterstitialLoading.value ||
        isRewardedInterstitialLoaded.value) {
      return;
    }

    isRewardedInterstitialLoading.value = true;

    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: _standardAdRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ [AdMob] Rewarded interstitial loaded ($unitId)');
          rewardedInterstitialAd = ad;
          isRewardedInterstitialLoaded.value = true;
          isRewardedInterstitialLoading.value = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ [AdMob] Rewarded interstitial failed: ${error.message}');
          isRewardedInterstitialLoading.value = false;
          isRewardedInterstitialLoaded.value = false;
          rewardedInterstitialAd = null;
        },
      ),
    );
  }

  void showRewardedInterstitialAd({
    required void Function(AdWithoutView ad, RewardItem reward)
        onUserEarnedReward,
    VoidCallback? onAdDismissed,
  }) {
    if (rewardedInterstitialAd == null ||
        !isRewardedInterstitialLoaded.value) {
      debugPrint('ℹ️ [AdMob] Rewarded interstitial not ready');
      onAdDismissed?.call();
      return;
    }

    rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        rewardedInterstitialAd = null;
        isRewardedInterstitialLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        rewardedInterstitialAd = null;
        isRewardedInterstitialLoaded.value = false;
        onAdDismissed?.call();
      },
    );

    rewardedInterstitialAd!.show(
      onUserEarnedReward: onUserEarnedReward,
    );
  }

  void disposeRewardedInterstitial() {
    rewardedInterstitialAd?.dispose();
    rewardedInterstitialAd = null;
    isRewardedInterstitialLoaded.value = false;
    isRewardedInterstitialLoading.value = false;
  }

  // ══════════════════════════════════════════════════════════════
  // APP OPEN ADS
  // ══════════════════════════════════════════════════════════════

  void loadAppOpenAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.appOpen;
    if (isAppOpenLoading.value || isAppOpenLoaded.value) return;

    _appOpenRetryTimer?.cancel();
    isAppOpenLoading.value = true;

    AppOpenAd.load(
      adUnitId: unitId,
      request: _standardAdRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ [AdMob] App Open Ad loaded successfully');
          appOpenAd = ad;
          isAppOpenLoaded.value = true;
          isAppOpenLoading.value = false;
          _appOpenRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ [AdMob] App Open failed: ${error.message}');
          isAppOpenLoading.value = false;
          isAppOpenLoaded.value = false;
          appOpenAd = null;

          if (_appOpenRetryCount < _maxRetries) {
            _appOpenRetryCount++;
            final delay = Duration(seconds: 1 << _appOpenRetryCount);
            _appOpenRetryTimer = Timer(delay, () => loadAppOpenAd(adUnitId: unitId));
          }
        },
      ),
    );
  }

  void showAppOpenAd({VoidCallback? onAdDismissed}) {
    if (appOpenAd == null || !isAppOpenLoaded.value) {
      debugPrint('ℹ️ [AdMob] App Open Ad not ready');
      onAdDismissed?.call();
      return;
    }

    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) =>
          debugPrint('📺 [AdMob] App Open Ad showed'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('🔙 [AdMob] App Open Ad dismissed');
        ad.dispose();
        appOpenAd = null;
        isAppOpenLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('⚠️ [AdMob] App Open Ad failed to show: ${error.message}');
        ad.dispose();
        appOpenAd = null;
        isAppOpenLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdImpression: (_) =>
          debugPrint('👁️ [AdMob] App Open Ad impression registered'),
    );

    appOpenAd!.show();
  }

  void disposeAppOpen() {
    _appOpenRetryTimer?.cancel();
    appOpenAd?.dispose();
    appOpenAd = null;
    isAppOpenLoaded.value = false;
    isAppOpenLoading.value = false;
    _appOpenRetryCount = 0;
  }

  // ══════════════════════════════════════════════════════════════
  // LIFECYCLE DISPOSAL
  // ══════════════════════════════════════════════════════════════

  @override
  void onClose() {
    disposeBanner();
    disposeRectangle();
    disposeNative();
    disposeInterstitial();
    disposeRewarded();
    disposeRewardedInterstitial();
    disposeAppOpen();
    super.onClose();
  }
}
