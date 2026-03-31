import 'package:opinion_easy/core/admob/ad_units.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/app_constants.dart';

class AdsController extends GetxController {
  // ── Banner ─────────────────────────────────────────────────
  BannerAd? bannerAd;
  final RxBool isLoaded = false.obs;

  // ── Native ─────────────────────────────────────────────────
  NativeAd? nativeAd;
  final RxBool isNativeLoaded = false.obs;

  // ── Rectangle (Medium Rectangle 300×250) ──────────────────
  BannerAd? rectangleAd;
  final RxBool isRectangleLoaded = false.obs;

  // ── Interstitial ───────────────────────────────────────────
  InterstitialAd? interstitialAd;
  final RxBool isInterstitialLoaded = false.obs;
  final RxBool isInterstitialLoading = false.obs;

  // ── Rewarded ───────────────────────────────────────────────
  RewardedAd? rewardedAd;
  final RxBool isRewardedLoaded = false.obs;
  final RxBool isRewardedLoading = false.obs;

  // ── Rewarded Interstitial ──────────────────────────────────
  RewardedInterstitialAd? rewardedInterstitialAd;
  final RxBool isRewardedInterstitialLoaded = false.obs;
  final RxBool isRewardedInterstitialLoading = false.obs;

  // ── App Open ───────────────────────────────────────────────
  AppOpenAd? appOpenAd;
  final RxBool isAppOpenLoaded = false.obs;
  final RxBool isAppOpenLoading = false.obs;

  // ══════════════════════════════════════════════════════════
  // DARK NATIVE TEMPLATE STYLE
  // ══════════════════════════════════════════════════════════
  static NativeTemplateStyle get _darkNativeStyle => NativeTemplateStyle(
        templateType: TemplateType.medium, // tall card (≈300 px slot)
        mainBackgroundColor: AppColor.bgCardAlt, // 0xFF1A1A1A — dark card bg
        cornerRadius: 16.0,

        // ── CTA button ──────────────────────────────────────
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.whiteColor, // white label
          backgroundColor: AppColor.blueAccent, // blue button fill
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),

        // ── Headline (app name / ad title) ──────────────────
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textPrimary, // 0xFFFFFFFF — white
          backgroundColor: AppColor.bgCardAlt, // seamless with card bg
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),

        // ── Subheadline / advertiser name ───────────────────
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textSecondary, // 0xFF9E9E9E — grey 400
          backgroundColor: AppColor.bgCardAlt,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),

        // ── Body copy / star-rating label ───────────────────
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColor.textMuted, // 0xFF757575 — grey 600
          backgroundColor: AppColor.bgCardAlt,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
      );

  // ══════════════════════════════════════════════════════════
  // BANNER — Adaptive
  // ══════════════════════════════════════════════════════════

  Future<void> loadAdaptiveBanner(
    BuildContext context, {
    String adUnitId = AdUnits.homeBanner,
  }) async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );
    if (size == null) {
      debugPrint('⚠️ Unable to get adaptive banner size');
      return;
    }

    bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isLoaded.value = true;
          debugPrint('✅ Banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner failed: $error');
          ad.dispose();
          bannerAd = null;
          isLoaded.value = false;
        },
        onAdOpened: (_) => debugPrint('📺 Banner opened.'),
        onAdClosed: (_) => debugPrint('🔙 Banner closed.'),
        onAdImpression: (_) => debugPrint('👁️ Banner impression.'),
        onAdClicked: (_) => debugPrint('🖱️ Banner clicked.'),
        onAdWillDismissScreen: (_) => debugPrint('⬇️ Banner will dismiss.'),
      ),
    );
    await bannerAd!.load();
  }

  void disposeBanner() {
    bannerAd?.dispose();
    bannerAd = null;
    isLoaded.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // RECTANGLE — Medium Rectangle 300×250
  // ══════════════════════════════════════════════════════════

  void loadRectangleAd({String adUnitId = AdUnits.resultRectangle}) {
    rectangleAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isRectangleLoaded.value = true;
          debugPrint('✅ Rectangle loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Rectangle failed: $error');
          ad.dispose();
          rectangleAd = null;
          isRectangleLoaded.value = false;
        },
        onAdOpened: (_) => debugPrint('📺 Rectangle opened.'),
        onAdClosed: (_) => debugPrint('🔙 Rectangle closed.'),
        onAdImpression: (_) => debugPrint('👁️ Rectangle impression.'),
        onAdClicked: (_) => debugPrint('🖱️ Rectangle clicked.'),
        onAdWillDismissScreen: (_) => debugPrint('⬇️ Rectangle will dismiss.'),
      ),
    )..load();
  }

  void disposeRectangle() {
    rectangleAd?.dispose();
    rectangleAd = null;
    isRectangleLoaded.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // NATIVE — dark themed
  // ══════════════════════════════════════════════════════════

  void loadNativeAd({String adUnitId = AdUnits.questionPageNative}) {
    if (isNativeLoaded.value || nativeAd != null) return;

    nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          isNativeLoaded.value = true;
          debugPrint('✅ Native loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Native failed: $error');
          ad.dispose();
          nativeAd = null;
          isNativeLoaded.value = false;
        },
        onAdOpened: (_) => debugPrint('📺 Native opened.'),
        onAdClosed: (_) => debugPrint('🔙 Native closed.'),
        onAdImpression: (_) => debugPrint('👁️ Native impression.'),
        onAdClicked: (_) => debugPrint('🖱️ Native clicked.'),
        onAdWillDismissScreen: (_) => debugPrint('⬇️ Native will dismiss.'),
      ),
      // ← Dark template applied here
      nativeTemplateStyle: _darkNativeStyle,
    );
    nativeAd!.load();
  }

  void disposeNative() {
    nativeAd?.dispose();
    nativeAd = null;
    isNativeLoaded.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // INTERSTITIAL
  // ══════════════════════════════════════════════════════════

  void loadInterstitialAd({String adUnitId = AdUnits.questionInterstitial}) {
    if (isInterstitialLoading.value || isInterstitialLoaded.value) return;
    isInterstitialLoading.value = true;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial loaded');
          interstitialAd = ad;
          isInterstitialLoaded.value = true;
          isInterstitialLoading.value = false;
          ad.fullScreenContentCallback = _interstitialFSCallback(adUnitId);
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial failed: $error');
          isInterstitialLoading.value = false;
          isInterstitialLoaded.value = false;
        },
      ),
    );
  }

  FullScreenContentCallback<InterstitialAd> _interstitialFSCallback(
    String adUnitId,
  ) {
    return FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => debugPrint('📺 Interstitial showed.'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('🔙 Interstitial dismissed.');
        ad.dispose();
        interstitialAd = null;
        isInterstitialLoaded.value = false;
        loadInterstitialAd(adUnitId: adUnitId);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('⚠️ Interstitial failed to show: $error');
        ad.dispose();
        interstitialAd = null;
        isInterstitialLoaded.value = false;
        loadInterstitialAd(adUnitId: adUnitId);
      },
      onAdImpression: (_) => debugPrint('👁️ Interstitial impression.'),
      onAdClicked: (_) => debugPrint('🖱️ Interstitial clicked.'),
    );
  }

  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (interstitialAd == null || !isInterstitialLoaded.value) {
      debugPrint('⚠️ Interstitial not ready');
      onAdDismissed?.call();
      return;
    }
    if (onAdDismissed != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (_) =>
            debugPrint('📺 Interstitial showed.'),
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          interstitialAd = null;
          isInterstitialLoaded.value = false;
          onAdDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          interstitialAd = null;
          isInterstitialLoaded.value = false;
          onAdDismissed();
        },
        onAdImpression: (_) => debugPrint('👁️ Interstitial impression.'),
        onAdClicked: (_) => debugPrint('🖱️ Interstitial clicked.'),
      );
    }
    interstitialAd!.show();
  }

  void disposeInterstitial() {
    interstitialAd?.dispose();
    interstitialAd = null;
    isInterstitialLoaded.value = false;
    isInterstitialLoading.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // REWARDED
  // ══════════════════════════════════════════════════════════

  void loadRewardedAd({String adUnitId = AdUnits.rewardedCoins}) {
    if (isRewardedLoading.value || isRewardedLoaded.value) return;
    isRewardedLoading.value = true;

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded loaded');
          rewardedAd = ad;
          isRewardedLoaded.value = true;
          isRewardedLoading.value = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) =>
                debugPrint('📺 Rewarded showed.'),
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAd = null;
              isRewardedLoaded.value = false;
              loadRewardedAd(adUnitId: adUnitId);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              rewardedAd = null;
              isRewardedLoaded.value = false;
              loadRewardedAd(adUnitId: adUnitId);
            },
            onAdImpression: (_) => debugPrint('👁️ Rewarded impression.'),
            onAdClicked: (_) => debugPrint('🖱️ Rewarded clicked.'),
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded failed: $error');
          isRewardedLoading.value = false;
          isRewardedLoaded.value = false;
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
      debugPrint('⚠️ Rewarded not ready');
      onAdDismissed?.call();
      return;
    }
    rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🎁 Reward: ${reward.amount} ${reward.type}');
        onUserEarnedReward(ad, reward);
      },
    );
  }

  void disposeRewarded() {
    rewardedAd?.dispose();
    rewardedAd = null;
    isRewardedLoaded.value = false;
    isRewardedLoading.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // REWARDED INTERSTITIAL
  // ══════════════════════════════════════════════════════════

  void loadRewardedInterstitialAd({
    String adUnitId = AdUnits.rewardedInterstitial,
  }) {
    if (isRewardedInterstitialLoading.value ||
        isRewardedInterstitialLoaded.value) return;
    isRewardedInterstitialLoading.value = true;

    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded interstitial loaded');
          rewardedInterstitialAd = ad;
          isRewardedInterstitialLoaded.value = true;
          isRewardedInterstitialLoading.value = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) =>
                debugPrint('📺 Rewarded interstitial showed.'),
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedInterstitialAd = null;
              isRewardedInterstitialLoaded.value = false;
              loadRewardedInterstitialAd(adUnitId: adUnitId);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              rewardedInterstitialAd = null;
              isRewardedInterstitialLoaded.value = false;
              loadRewardedInterstitialAd(adUnitId: adUnitId);
            },
            onAdImpression: (_) =>
                debugPrint('👁️ Rewarded interstitial impression.'),
            onAdClicked: (_) =>
                debugPrint('🖱️ Rewarded interstitial clicked.'),
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded interstitial failed: $error');
          isRewardedInterstitialLoading.value = false;
          isRewardedInterstitialLoaded.value = false;
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
      debugPrint('⚠️ Rewarded interstitial not ready');
      onAdDismissed?.call();
      return;
    }
    rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint(
          '🎁 Rewarded interstitial reward: ${reward.amount} ${reward.type}',
        );
        onUserEarnedReward(ad, reward);
      },
    );
  }

  void disposeRewardedInterstitial() {
    rewardedInterstitialAd?.dispose();
    rewardedInterstitialAd = null;
    isRewardedInterstitialLoaded.value = false;
    isRewardedInterstitialLoading.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // APP OPEN
  // ══════════════════════════════════════════════════════════

  void loadAppOpenAd({String adUnitId = AdUnits.appOpen}) {
    if (isAppOpenLoading.value || isAppOpenLoaded.value) return;
    isAppOpenLoading.value = true;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ App open loaded');
          appOpenAd = ad;
          isAppOpenLoaded.value = true;
          isAppOpenLoading.value = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) =>
                debugPrint('📺 App open showed.'),
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('🔙 App open dismissed.');
              ad.dispose();
              appOpenAd = null;
              isAppOpenLoaded.value = false;
              loadAppOpenAd(adUnitId: adUnitId);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              appOpenAd = null;
              isAppOpenLoaded.value = false;
              loadAppOpenAd(adUnitId: adUnitId);
            },
            onAdImpression: (_) => debugPrint('👁️ App open impression.'),
            onAdClicked: (_) => debugPrint('🖱️ App open clicked.'),
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ App open failed: $error');
          isAppOpenLoading.value = false;
          isAppOpenLoaded.value = false;
        },
      ),
    );
  }

  void showAppOpenAd({VoidCallback? onAdDismissed}) {
    if (appOpenAd == null || !isAppOpenLoaded.value) {
      debugPrint('⚠️ App open not ready');
      onAdDismissed?.call();
      return;
    }
    appOpenAd!.show();
  }

  void disposeAppOpen() {
    appOpenAd?.dispose();
    appOpenAd = null;
    isAppOpenLoaded.value = false;
    isAppOpenLoading.value = false;
  }

  // ══════════════════════════════════════════════════════════
  // LIFECYCLE
  // ══════════════════════════════════════════════════════════

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
