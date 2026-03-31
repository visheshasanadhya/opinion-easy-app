class AdUnits {
  AdUnits._(); // prevent instantiation

  // ── App ID ────────────────────────────────────────────────
  static const String appId = "ca-app-pub-4639427395020302~XXXXXXXXXX";

  // ── Banner Ads ────────────────────────────────────────────
  /// Standard adaptive banner shown at bottom of HomeView
  static const String homeBanner = "ca-app-pub-2884539585662970/4075674748";

  /// Banner shown inside confirmation dialog (top slot)
  static const String dialogTopBanner =
      "ca-app-pub-2884539585662970/4075674748";

  /// Banner shown inside confirmation dialog (bottom slot)
  static const String dialogBottomBanner =
      "ca-app-pub-2884539585662970/4075674748";

  // ── Native Ads ────────────────────────────────────────────
  /// Native ad shown in SubCategView (middle position)
  static const String subCategMiddleNative =
      "ca-app-pub-2884539585662970/1222280693";

  /// Native ad shown in SubCategView (end / bottom position)
  static const String subCategEndNative =
      "ca-app-pub-2884539585662970/1222280693";

  /// Native ad shown per question page inside QuestionView
  static const String questionPageNative =
      "ca-app-pub-2884539585662970/1222280693";

  // ── Interstitial Ads ──────────────────────────────────────
  /// Full-screen interstitial shown every 10 answered questions
  static const String questionInterstitial =
      "ca-app-pub-2884539585662970/5525651506";

  // ── Rectangle (Medium Rectangle 300×250) Ads ─────────────
  /// Medium rectangle shown on result / summary screens
  static const String resultRectangle =
      "ca-app-pub-4639427395020302/XXXXXXXXXX";

  // ── Rewarded Ads ──────────────────────────────────────────
  /// Rewarded ad — user watches to earn bonus coins
  static const String rewardedCoins = "ca-app-pub-4639427395020302/XXXXXXXXXX";

  /// Rewarded interstitial — shown between question sets
  static const String rewardedInterstitial =
      "ca-app-pub-4639427395020302/XXXXXXXXXX";

  // ── App Open Ads ──────────────────────────────────────────
  /// App open ad shown on cold / warm app launch
  static const String appOpen = "ca-app-pub-2884539585662970/8071448435";
}
