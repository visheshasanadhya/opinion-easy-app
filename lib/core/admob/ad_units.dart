import 'package:flutter/foundation.dart';

/// AdMob Ad Unit IDs and configuration.
///
/// In debug mode, Google's official test ad unit IDs are automatically
/// served so that developer/QA testing does not trigger AdMob policy violations,
/// invalid traffic flags, or drop account eCPM.
///
/// In release mode, live production IDs from your Google AdMob account are served.
class AdUnits {
  AdUnits._();

  // ══════════════════════════════════════════════════════════════════════════
  // GOOGLE OFFICIAL TEST AD UNIT IDS (Android)
  // ══════════════════════════════════════════════════════════════════════════
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedInterstitial =
      'ca-app-pub-3940256099942544/5354046379';
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/9257390321';

  // ══════════════════════════════════════════════════════════════════════════
  // PRODUCTION ADMOB IDs
  // ══════════════════════════════════════════════════════════════════════════
  static const String _prodAppId = 'ca-app-pub-2884539585662970~7479919514';
  static const String _prodHomeBanner =
      'ca-app-pub-2884539585662970/4075674748';
  static const String _prodSubCategMiddleNative =
      'ca-app-pub-2884539585662970/1222280693';
  static const String _prodSubCategEndNative =
      'ca-app-pub-2884539585662970/1222280693';
  static const String _prodQuestionPageNative =
      'ca-app-pub-2884539585662970/1222280693';
  static const String _prodQuestionInterstitial =
      'ca-app-pub-2884539585662970/5525651506';
  static const String _prodAppOpen = 'ca-app-pub-2884539585662970/8071448435';

  // Helper method: returns test ID in debug mode or if production ID is placeholder
  static String _resolve(String prodId, String testId) {
    if (kDebugMode || prodId.contains('XXXX')) {
      return testId;
    }
    return prodId;
  }

  // ── App ID ──────────────────────────────────────────────────────────────
  static String get appId => _prodAppId;

  // ── Banner Ads ──────────────────────────────────────────────────────────
  /// Adaptive banner shown on HomeView & Cricket/Stock views
  static String get homeBanner => _resolve(_prodHomeBanner, _testBanner);

  /// Banner shown inside confirmation dialog (top slot)
  static String get dialogTopBanner =>
      _resolve(_prodHomeBanner, _testBanner);

  /// Banner shown inside confirmation dialog (bottom slot)
  static String get dialogBottomBanner =>
      _resolve(_prodHomeBanner, _testBanner);

  // ── Native Ads ──────────────────────────────────────────────────────────
  /// Native ad shown in SubCategView (middle position)
  static String get subCategMiddleNative =>
      _resolve(_prodSubCategMiddleNative, _testNative);

  /// Native ad shown in SubCategView (bottom position)
  static String get subCategEndNative =>
      _resolve(_prodSubCategEndNative, _testNative);

  /// Native ad shown per question card in QuestionView
  static String get questionPageNative =>
      _resolve(_prodQuestionPageNative, _testNative);

  // ── Interstitial Ads ────────────────────────────────────────────────────
  /// Full-screen interstitial shown during question flow
  static String get questionInterstitial =>
      _resolve(_prodQuestionInterstitial, _testInterstitial);

  // ── Rectangle Ads ───────────────────────────────────────────────────────
  /// Medium Rectangle (300×250)
  static String get resultRectangle => _resolve(_prodHomeBanner, _testBanner);

  // ── Rewarded Ads ────────────────────────────────────────────────────────
  /// Rewarded video ad for bonus coin rewards
  static String get rewardedCoins => _resolve(_testRewarded, _testRewarded);

  /// Rewarded interstitial ad
  static String get rewardedInterstitial =>
      _resolve(_testRewardedInterstitial, _testRewardedInterstitial);

  // ── App Open Ads ────────────────────────────────────────────────────────
  /// App Open ad shown on app launch / resume
  static String get appOpen => _resolve(_prodAppOpen, _testAppOpen);
}
