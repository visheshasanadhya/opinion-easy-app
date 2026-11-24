import 'package:flutter/foundation.dart';

class AdUnits {
  AdUnits._();

  // ── Test Unit IDs ────────────────────────────────────────────
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedInterstitial =
      'ca-app-pub-3940256099942544/5354046379';
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/9257390321';

  // ── Production Unit IDs ──────────────────────────────────────
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

  static String _resolve(String prodId, String testId) {
    return (kDebugMode || prodId.contains('XXXX')) ? testId : prodId;
  }

  // ── App ID ───────────────────────────────────────────────────
  static String get appId => _prodAppId;

  // ── Banner Ads ───────────────────────────────────────────────
  static String get homeBanner => _resolve(_prodHomeBanner, _testBanner);
  static String get dialogTopBanner => _resolve(_prodHomeBanner, _testBanner);
  static String get dialogBottomBanner => _resolve(_prodHomeBanner, _testBanner);

  // ── Native Ads ───────────────────────────────────────────────
  static String get subCategMiddleNative =>
      _resolve(_prodSubCategMiddleNative, _testNative);
  static String get subCategEndNative =>
      _resolve(_prodSubCategEndNative, _testNative);
  static String get questionPageNative =>
      _resolve(_prodQuestionPageNative, _testNative);

  // ── Interstitial Ads ─────────────────────────────────────────
  static String get questionInterstitial =>
      _resolve(_prodQuestionInterstitial, _testInterstitial);

  // ── Rectangle Ads ────────────────────────────────────────────
  static String get resultRectangle => _resolve(_prodHomeBanner, _testBanner);

  // ── Rewarded Ads ─────────────────────────────────────────────
  static String get rewardedCoins => _resolve(_testRewarded, _testRewarded);
  static String get rewardedInterstitial =>
      _resolve(_testRewardedInterstitial, _testRewardedInterstitial);

  // ── App Open Ads ─────────────────────────────────────────────
  static String get appOpen => _resolve(_prodAppOpen, _testAppOpen);
}
