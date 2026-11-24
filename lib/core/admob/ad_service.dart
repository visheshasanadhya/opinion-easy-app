import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:opinion_easy/core/admob/ad_units.dart';

typedef AdPreloadService = AdService;

class AdService extends GetxService with WidgetsBindingObserver {
  static AdService get to => Get.find<AdService>();

  // ── App Open Ad ──────────────────────────────────────────────
  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoading = false;
  DateTime? _lastAppOpenShowTime;
  static const int _appOpenFrequencyCapMinutes = 4;
  bool isAppOpenSuppressed = false;

  void setAppOpenSuppressed(bool suppressed) {
    isAppOpenSuppressed = suppressed;
  }

  void preloadAppOpenAd() {
    if (_appOpenAd != null || _isAppOpenLoading) return;
    _isAppOpenLoading = true;

    AppOpenAd.load(
      adUnitId: AdUnits.appOpen,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenLoading = false;
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _isAppOpenLoading = false;
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable({VoidCallback? onAdDismissed}) {
    if (isAppOpenSuppressed) {
      onAdDismissed?.call();
      return;
    }

    if (_appOpenAd == null) {
      preloadAppOpenAd();
      onAdDismissed?.call();
      return;
    }

    if (_lastAppOpenShowTime != null &&
        DateTime.now().difference(_lastAppOpenShowTime!).inMinutes <
            _appOpenFrequencyCapMinutes) {
      onAdDismissed?.call();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        _lastAppOpenShowTime = DateTime.now();
        preloadAppOpenAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd = null;
        preloadAppOpenAd();
        onAdDismissed?.call();
      },
    );

    _appOpenAd!.show();
  }

  // ── Interstitial Ad ──────────────────────────────────────────
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  void preloadInterstitial() {
    if (_interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdUnits.questionInterstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  void showInterstitial({required VoidCallback onComplete}) {
    if (_interstitialAd == null) {
      preloadInterstitial();
      onComplete();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
        onComplete();
      },
    );

    _interstitialAd!.show();
  }

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    preloadAppOpenAd();
    preloadInterstitial();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isAppOpenSuppressed) {
      showAppOpenAdIfAvailable();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _interstitialAd?.dispose();
    _interstitialAd = null;
    super.onClose();
  }
}
