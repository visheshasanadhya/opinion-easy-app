import 'package:flutter/foundation.dart';

/// Centralized Google AdMob ad unit IDs.
///
/// Follows standard AdMob architecture: ONE ID per ad format.
/// Screen-specific IDs should only be added if separately provisioned
/// in the AdMob Dashboard for granular reporting.
class AdUnits {
  AdUnits._();

  // ── App ID ───────────────────────────────────────────────────
  static const String appId = 'ca-app-pub-2884539585662970~7479919514';

  // ── Test Unit IDs (Official Google Test IDs) ─────────────────
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedInterstitial =
      'ca-app-pub-3940256099942544/5354046379';
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/9257390321';

  // ── Production Unit IDs (One per format) ─────────────────────
  static const String _prodBanner = 'ca-app-pub-2884539585662970/4075674748';
  static const String _prodNative = 'ca-app-pub-2884539585662970/1222280693';
  static const String _prodInterstitial =
      'ca-app-pub-2884539585662970/5525651506';
  static const String _prodAppOpen = 'ca-app-pub-2884539585662970/8071448435';

  static String _resolve(String prodId, String testId) {
    return (kDebugMode || prodId.contains('XXXX')) ? testId : prodId;
  }

  // ── Format Getters ───────────────────────────────────────────
  static String get banner => _resolve(_prodBanner, _testBanner);
  static String get native => _resolve(_prodNative, _testNative);
  static String get interstitial =>
      _resolve(_prodInterstitial, _testInterstitial);
  static String get appOpen => _resolve(_prodAppOpen, _testAppOpen);
  static String get rewarded => _resolve(_testRewarded, _testRewarded);
  static String get rewardedInterstitial =>
      _resolve(_testRewardedInterstitial, _testRewardedInterstitial);
}
