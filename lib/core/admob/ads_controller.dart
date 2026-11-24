import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:opinion_easy/core/admob/ad_units.dart';
import '../utils/app_constants.dart';

class AdsController extends GetxController {
  // ── Banner Ad ────────────────────────────────────────────────
  BannerAd? bannerAd;
  final RxBool isLoaded = false.obs;
  int _bannerRetryCount = 0;
  Timer? _bannerRetryTimer;

  // ── Native Ad ────────────────────────────────────────────────
  NativeAd? nativeAd;
  final RxBool isNativeLoaded = false.obs;
  int _nativeRetryCount = 0;
  Timer? _nativeRetryTimer;

  // ── Rectangle Ad ─────────────────────────────────────────────
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
  static const AdRequest _adRequest = AdRequest(httpTimeoutMillis: 10000);

  // ── Native Template Style ────────────────────────────────────
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

  // ── Adaptive Banner Methods ──────────────────────────────────
  Future<void> loadAdaptiveBanner(
    BuildContext context, {
    String? adUnitId,
  }) async {
    final unitId = adUnitId ?? AdUnits.homeBanner;
    _bannerRetryTimer?.cancel();

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );
    if (size == null) return;

    await bannerAd?.dispose();
    bannerAd = null;
    isLoaded.value = false;

    bannerAd = BannerAd(
      adUnitId: unitId,
      size: size,
      request: _adRequest,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isLoaded.value = true;
          _bannerRetryCount = 0;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          bannerAd = null;
          isLoaded.value = false;
          if (_bannerRetryCount < _maxRetries) {
            _bannerRetryCount++;
            _bannerRetryTimer = Timer(
              Duration(seconds: 1 << _bannerRetryCount),
              () => context.mounted ? loadAdaptiveBanner(context, adUnitId: unitId) : null,
            );
          }
        },
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

  // ── Rectangle Ad Methods ─────────────────────────────────────
  void loadRectangleAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.resultRectangle;
    _rectangleRetryTimer?.cancel();

    rectangleAd?.dispose();
    rectangleAd = null;
    isRectangleLoaded.value = false;

    rectangleAd = BannerAd(
      adUnitId: unitId,
      size: AdSize.mediumRectangle,
      request: _adRequest,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isRectangleLoaded.value = true;
          _rectangleRetryCount = 0;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          rectangleAd = null;
          isRectangleLoaded.value = false;
          if (_rectangleRetryCount < _maxRetries) {
            _rectangleRetryCount++;
            _rectangleRetryTimer = Timer(
              Duration(seconds: 1 << _rectangleRetryCount),
              () => loadRectangleAd(adUnitId: unitId),
            );
          }
        },
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

  // ── Native Ad Methods ────────────────────────────────────────
  void loadNativeAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.questionPageNative;
    if (isNativeLoaded.value && nativeAd != null) return;

    _nativeRetryTimer?.cancel();
    nativeAd?.dispose();
    nativeAd = null;
    isNativeLoaded.value = false;

    nativeAd = NativeAd(
      adUnitId: unitId,
      request: _adRequest,
      nativeTemplateStyle: darkNativeStyle,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          isNativeLoaded.value = true;
          _nativeRetryCount = 0;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          nativeAd = null;
          isNativeLoaded.value = false;
          if (_nativeRetryCount < _maxRetries) {
            _nativeRetryCount++;
            _nativeRetryTimer = Timer(
              Duration(seconds: 1 << _nativeRetryCount),
              () => loadNativeAd(adUnitId: unitId),
            );
          }
        },
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

  // ── Interstitial Ad Methods ──────────────────────────────────
  void loadInterstitialAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.questionInterstitial;
    if (isInterstitialLoading.value || isInterstitialLoaded.value) return;

    _interstitialRetryTimer?.cancel();
    isInterstitialLoading.value = true;

    InterstitialAd.load(
      adUnitId: unitId,
      request: _adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialLoaded.value = true;
          isInterstitialLoading.value = false;
          _interstitialRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          isInterstitialLoading.value = false;
          isInterstitialLoaded.value = false;
          interstitialAd = null;
          if (_interstitialRetryCount < _maxRetries) {
            _interstitialRetryCount++;
            _interstitialRetryTimer = Timer(
              Duration(seconds: 1 << _interstitialRetryCount),
              () => loadInterstitialAd(adUnitId: unitId),
            );
          }
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (interstitialAd == null || !isInterstitialLoaded.value) {
      onAdDismissed?.call();
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        interstitialAd = null;
        isInterstitialLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        interstitialAd = null;
        isInterstitialLoaded.value = false;
        onAdDismissed?.call();
      },
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

  // ── Rewarded Ad Methods ──────────────────────────────────────
  void loadRewardedAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.rewardedCoins;
    if (isRewardedLoading.value || isRewardedLoaded.value) return;

    _rewardedRetryTimer?.cancel();
    isRewardedLoading.value = true;

    RewardedAd.load(
      adUnitId: unitId,
      request: _adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isRewardedLoaded.value = true;
          isRewardedLoading.value = false;
          _rewardedRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          isRewardedLoading.value = false;
          isRewardedLoaded.value = false;
          rewardedAd = null;
          if (_rewardedRetryCount < _maxRetries) {
            _rewardedRetryCount++;
            _rewardedRetryTimer = Timer(
              Duration(seconds: 1 << _rewardedRetryCount),
              () => loadRewardedAd(adUnitId: unitId),
            );
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
      onAdDismissed?.call();
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        rewardedAd = null;
        isRewardedLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        rewardedAd = null;
        isRewardedLoaded.value = false;
        onAdDismissed?.call();
      },
    );
    rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
  }

  void disposeRewarded() {
    _rewardedRetryTimer?.cancel();
    rewardedAd?.dispose();
    rewardedAd = null;
    isRewardedLoaded.value = false;
    isRewardedLoading.value = false;
    _rewardedRetryCount = 0;
  }

  // ── Rewarded Interstitial Methods ────────────────────────────
  void loadRewardedInterstitialAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.rewardedInterstitial;
    if (isRewardedInterstitialLoading.value ||
        isRewardedInterstitialLoaded.value) {
      return;
    }

    isRewardedInterstitialLoading.value = true;

    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: _adRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedInterstitialAd = ad;
          isRewardedInterstitialLoaded.value = true;
          isRewardedInterstitialLoading.value = false;
        },
        onAdFailedToLoad: (error) {
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
    if (rewardedInterstitialAd == null || !isRewardedInterstitialLoaded.value) {
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
    rewardedInterstitialAd!.show(onUserEarnedReward: onUserEarnedReward);
  }

  void disposeRewardedInterstitial() {
    rewardedInterstitialAd?.dispose();
    rewardedInterstitialAd = null;
    isRewardedInterstitialLoaded.value = false;
    isRewardedInterstitialLoading.value = false;
  }

  // ── App Open Ad Methods ──────────────────────────────────────
  void loadAppOpenAd({String? adUnitId}) {
    final unitId = adUnitId ?? AdUnits.appOpen;
    if (isAppOpenLoading.value || isAppOpenLoaded.value) return;

    _appOpenRetryTimer?.cancel();
    isAppOpenLoading.value = true;

    AppOpenAd.load(
      adUnitId: unitId,
      request: _adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          isAppOpenLoaded.value = true;
          isAppOpenLoading.value = false;
          _appOpenRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          isAppOpenLoading.value = false;
          isAppOpenLoaded.value = false;
          appOpenAd = null;
          if (_appOpenRetryCount < _maxRetries) {
            _appOpenRetryCount++;
            _appOpenRetryTimer = Timer(
              Duration(seconds: 1 << _appOpenRetryCount),
              () => loadAppOpenAd(adUnitId: unitId),
            );
          }
        },
      ),
    );
  }

  void showAppOpenAd({VoidCallback? onAdDismissed}) {
    if (appOpenAd == null || !isAppOpenLoaded.value) {
      onAdDismissed?.call();
      return;
    }

    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        appOpenAd = null;
        isAppOpenLoaded.value = false;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        appOpenAd = null;
        isAppOpenLoaded.value = false;
        onAdDismissed?.call();
      },
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

  // ── Lifecycle Disposal ───────────────────────────────────────
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
