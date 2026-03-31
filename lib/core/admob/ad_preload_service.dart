import 'package:opinion_easy/core/admob/ad_units.dart';
import 'package:opinion_easy/core/admob/admob.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
class AdPreloadService extends GetxService with WidgetsBindingObserver {
  // ── Singleton controllers ──────────────────────────────────
  final AdsController subCategMiddle = AdsController();
  final AdsController subCategEnd = AdsController();
  final AdsController appOpenController = AdsController();

  final List<AdsController> _questionPool = [];
  static const int _poolSize = 3;

  static const int _appOpenFrequencyCapMinutes = 5;
  DateTime? _lastAdShowTime;

  // ── Lifecycle ──────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
    _fillPool();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      showAppOpenAdIfAvailable();
    }
  }

  // ── Public API ─────────────────────────────────────────────

  /// Shows the App Open Ad with frequency cap and readiness checks.
  void showAppOpenAdIfAvailable({VoidCallback? onAdDismissed}) {
    if (!appOpenController.isAppOpenLoaded.value) {
      debugPrint('ℹ️ App Open Ad not ready.');
      onAdDismissed?.call();
      return;
    }

    if (_lastAdShowTime != null &&
        DateTime.now().difference(_lastAdShowTime!).inMinutes <
            _appOpenFrequencyCapMinutes) {
      debugPrint('ℹ️ App Open Ad skipped (frequency cap active).');
      onAdDismissed?.call();
      return;
    }

    appOpenController.showAppOpenAd(
      onAdDismissed: () {
        _lastAdShowTime = DateTime.now();
        // Reload once for the next resume.
        appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
        onAdDismissed?.call();
      },
    );
  }

  /// Called every time SubCategView opens.
  /// Disposes any previous ad and loads once — no retries.
  void refreshSubCategAds() {
    subCategMiddle.disposeNative();
    subCategMiddle.loadNativeAd(adUnitId: AdUnits.subCategMiddleNative);

    subCategEnd.disposeNative();
    subCategEnd.loadNativeAd(adUnitId: AdUnits.subCategEndNative);
  }

  /// Returns a ready native-ad controller from the pool, or a fresh one if
  /// none are ready yet.  Automatically refills the pool after consuming.
  AdsController consumeFromPool() {
    for (int i = 0; i < _questionPool.length; i++) {
      final ctrl = _questionPool[i];
      if (ctrl.isNativeLoaded.value && ctrl.nativeAd != null) {
        _questionPool.removeAt(i);
        _fillPool();
        return ctrl;
      }
    }
    // No ready ad yet — return a loading controller outside the pool.
    final fresh = AdsController();
    fresh.loadNativeAd(adUnitId: AdUnits.questionPageNative);
    return fresh;
  }

  // ── Private ────────────────────────────────────────────────

  /// Fills the question-ad pool up to [_poolSize], loading each slot once.
  void _fillPool() {
    while (_questionPool.length < _poolSize) {
      final ctrl = AdsController();
      _questionPool.add(ctrl);
      ctrl.loadNativeAd(adUnitId: AdUnits.questionPageNative);
    }
  }

  // ── Cleanup ────────────────────────────────────────────────

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    subCategMiddle.disposeNative();
    subCategEnd.disposeNative();
    appOpenController.disposeAppOpen();

    for (final ctrl in _questionPool) {
      ctrl.disposeNative();
    }
    _questionPool.clear();

    super.onClose();
  }
}
