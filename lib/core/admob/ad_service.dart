import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/admob/ad_units.dart';
import 'package:opinion_easy/core/admob/ads_controller.dart';

typedef AdService = AdPreloadService;

class AdPreloadService extends GetxService with WidgetsBindingObserver {
  // ── Controllers ──────────────────────────────────────────────
  final AdsController subCategMiddle = AdsController();
  final AdsController subCategEnd = AdsController();
  final AdsController appOpenController = AdsController();

  final List<AdsController> _questionPool = [];
  static const int _poolSize = 2;

  static const int _appOpenFrequencyCapMinutes = 4;
  DateTime? _lastAdShowTime;
  bool isAppOpenSuppressed = false;

  void setAppOpenSuppressed(bool suppressed) {
    isAppOpenSuppressed = suppressed;
  }

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
    _fillPool();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isAppOpenSuppressed) {
      showAppOpenAdIfAvailable();
    }
  }

  // ── App Open Flow ────────────────────────────────────────────
  void showAppOpenAdIfAvailable({VoidCallback? onAdDismissed}) {
    if (isAppOpenSuppressed) {
      onAdDismissed?.call();
      return;
    }

    if (!appOpenController.isAppOpenLoaded.value ||
        appOpenController.appOpenAd == null) {
      appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
      onAdDismissed?.call();
      return;
    }

    if (_lastAdShowTime != null &&
        DateTime.now().difference(_lastAdShowTime!).inMinutes <
            _appOpenFrequencyCapMinutes) {
      onAdDismissed?.call();
      return;
    }

    appOpenController.showAppOpenAd(
      onAdDismissed: () {
        _lastAdShowTime = DateTime.now();
        appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
        onAdDismissed?.call();
      },
    );
  }

  // ── Native Subcategory Placements ────────────────────────────
  void refreshSubCategAds() {
    if (!subCategMiddle.isNativeLoaded.value && subCategMiddle.nativeAd == null) {
      subCategMiddle.loadNativeAd(adUnitId: AdUnits.subCategMiddleNative);
    }
    if (!subCategEnd.isNativeLoaded.value && subCategEnd.nativeAd == null) {
      subCategEnd.loadNativeAd(adUnitId: AdUnits.subCategEndNative);
    }
  }

  // ── Native Question Pool ─────────────────────────────────────
  AdsController consumeFromPool() {
    for (int i = 0; i < _questionPool.length; i++) {
      final ctrl = _questionPool[i];
      if (ctrl.isNativeLoaded.value && ctrl.nativeAd != null) {
        _questionPool.removeAt(i);
        _fillPool();
        return ctrl;
      }
    }

    final fresh = AdsController();
    fresh.loadNativeAd(adUnitId: AdUnits.questionPageNative);
    _fillPool();
    return fresh;
  }

  void _fillPool() {
    while (_questionPool.length < _poolSize) {
      final ctrl = AdsController();
      _questionPool.add(ctrl);
      ctrl.loadNativeAd(adUnitId: AdUnits.questionPageNative);
    }
  }

  // ── Disposal ─────────────────────────────────────────────────
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    subCategMiddle.dispose();
    subCategEnd.dispose();
    appOpenController.dispose();
    for (final ctrl in _questionPool) {
      ctrl.dispose();
    }
    _questionPool.clear();
    super.onClose();
  }
}
