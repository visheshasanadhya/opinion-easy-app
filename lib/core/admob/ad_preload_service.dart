import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/admob/ad_units.dart';
import 'package:opinion_easy/core/admob/admob.dart';

/// Enterprise Ad Preload Service managing foreground App Open Ads,
/// high-value Native Ad pooling, and frequency capping.
class AdPreloadService extends GetxService with WidgetsBindingObserver {
  // ── Singleton Controllers for Fixed Placements ───────────────
  final AdsController subCategMiddle = AdsController();
  final AdsController subCategEnd = AdsController();
  final AdsController appOpenController = AdsController();

  // ── Question Native Ad Pool ──────────────────────────────────
  final List<AdsController> _questionPool = [];
  static const int _poolSize = 2; // Optimal size: prevents wasted ad requests

  // ── App Open Frequency Capping ───────────────────────────────
  static const int _appOpenFrequencyCapMinutes = 4;
  DateTime? _lastAdShowTime;

  /// Flag to suppress App Open Ads during sensitive workflows
  /// (e.g. Google Sign-in, camera photo pick, or payment webviews)
  bool isAppOpenSuppressed = false;

  void setAppOpenSuppressed(bool suppressed) {
    isAppOpenSuppressed = suppressed;
    debugPrint('ℹ️ [AdPreloadService] App open suppression: $suppressed');
  }

  // ── Lifecycle ────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // Initial preload for launch
    appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
    _fillPool();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isAppOpenSuppressed) {
      showAppOpenAdIfAvailable();
    }
  }

  // ── Public API ───────────────────────────────────────────────

  /// Shows the App Open Ad with frequency cap, suppression, and readiness checks.
  void showAppOpenAdIfAvailable({VoidCallback? onAdDismissed}) {
    if (isAppOpenSuppressed) {
      debugPrint('ℹ️ [AdPreloadService] App Open Ad suppressed by active flow');
      onAdDismissed?.call();
      return;
    }

    if (!appOpenController.isAppOpenLoaded.value ||
        appOpenController.appOpenAd == null) {
      debugPrint('ℹ️ [AdPreloadService] App Open Ad not ready yet');
      // Request preload for next time
      appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
      onAdDismissed?.call();
      return;
    }

    if (_lastAdShowTime != null &&
        DateTime.now().difference(_lastAdShowTime!).inMinutes <
            _appOpenFrequencyCapMinutes) {
      debugPrint('ℹ️ [AdPreloadService] App Open Ad skipped (frequency cap active)');
      onAdDismissed?.call();
      return;
    }

    appOpenController.showAppOpenAd(
      onAdDismissed: () {
        _lastAdShowTime = DateTime.now();
        // Preload next ad ready for the next session
        appOpenController.loadAppOpenAd(adUnitId: AdUnits.appOpen);
        onAdDismissed?.call();
      },
    );
  }

  /// Refreshes Native ads for Subcategory view
  void refreshSubCategAds() {
    subCategMiddle.disposeNative();
    subCategMiddle.loadNativeAd(adUnitId: AdUnits.subCategMiddleNative);

    subCategEnd.disposeNative();
    subCategEnd.loadNativeAd(adUnitId: AdUnits.subCategEndNative);
  }

  /// Returns a ready native-ad controller from the pool, or creates a fresh one.
  /// Automatically refills the pool to maintain instant responsiveness.
  AdsController consumeFromPool() {
    for (int i = 0; i < _questionPool.length; i++) {
      final ctrl = _questionPool[i];
      if (ctrl.isNativeLoaded.value && ctrl.nativeAd != null) {
        _questionPool.removeAt(i);
        _fillPool();
        return ctrl;
      }
    }

    // No ready ad in pool yet: instantiate and load directly
    final fresh = AdsController();
    fresh.loadNativeAd(adUnitId: AdUnits.questionPageNative);
    _fillPool();
    return fresh;
  }

  // ── Private Pool Management ──────────────────────────────────

  void _fillPool() {
    while (_questionPool.length < _poolSize) {
      final ctrl = AdsController();
      _questionPool.add(ctrl);
      ctrl.loadNativeAd(adUnitId: AdUnits.questionPageNative);
    }
  }

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
