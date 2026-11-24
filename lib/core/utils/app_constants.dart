import 'package:flutter/material.dart';

export 'app_asset.dart';

// ════════════════════════════════════════════════════════════
//  AppColor
// ════════════════════════════════════════════════════════════
class AppColor {
  AppColor._();

  // Backgrounds
  static const Color scaffold = Color(0xFF000000);
  static const Color card = Color(0xFF141414);
  static const Color cardAlt = Color(0xFF1A1A1A);
  static const Color cardLight = Color(0xFF242424);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color textMuted = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF616161);

  // Borders
  static const Color borderFaint = Color(0x14FFFFFF); //  8%
  static const Color borderLight = Color(0x1AFFFFFF); // 10%
  static const Color borderStrong = Color(0xFFFFFFFF); // 100%

  // Brand
  static const Color blue = Color(0xFF4A90E2);
  static const Color blueDark = Color(0xFF357ABD);
  static const Color purple = Color(0xFF6F63FF);
  static const Color purpleDark = Color(0xFF5A4EFF);

  // Semantic
  static const Color green = Color(0xFF4CAF50);
  static const Color red = Color(0xFFFF4757);
  static const Color redAlt = Color(0xFFEF4444);
  static const Color orange = Color(0xFFFF9800);
  static const Color yellow = Color(0xFFFFEB3B);

  // Podium
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Shimmer
  static const Color shimmerBase = Color(0xFF1E1E1E);
  static const Color shimmerHighlight = Color(0xFF2A2A2A);

  // Gradients
  static const List<Color> gradientBlue = [
    Color(0xFF4A90E2),
    Color(0xFF357ABD)
  ];
  static const List<Color> gradientGold = [
    Color(0xFFFFD200),
    Color(0xFFF7971E)
  ];
  static const List<Color> gradientNotif = [
    Color(0xFFFF512F),
    Color(0xFFDD2476)
  ];
  static const List<Color> gradientPurple = [
    Color(0xFF6F63FF),
    Color(0xFF5A4EFF)
  ];

  // Helpers
  static Color whiteOp(double opacity) => Colors.white.withOpacity(opacity);
  static Color blackOp(double opacity) => Colors.black.withOpacity(opacity);

  // ── Legacy aliases ──────────────────────────────────────────────────────────
  static const Color bgDeep = scaffold;
  static const Color bgCard = card;
  static const Color bgCardAlt = cardAlt;
  static const Color bgCardLight = cardLight;
  static const Color textPrimary = textWhite;
  static const Color textSecondary = textGrey;
  static const Color borderSubtle = borderFaint;
  static const Color borderMedium = borderLight;
  static const Color blueAccent = blue;
  static const Color greenColor = green;
  static const Color redColor = red;
  static const Color whiteColor = white;
  static const Color blackColor = black;
  static const Color primaryColor1 = white;
  static const Color primaryColor2 = blue;
  static const Color greyColor = textGrey;
  static const Color lightGrey = Color(0xFF7B7B7B);
  static const Color whileColor = white; // legacy typo alias
  static const List<Color> goldGradient = gradientGold;
  static const List<Color> blueGradient = gradientBlue;
  static const List<Color> notifGradient = gradientNotif;
}

// ════════════════════════════════════════════════════════════
//  AppText  —  text styles
// ════════════════════════════════════════════════════════════
class AppText {
  AppText._();

  // Display
  static const TextStyle display = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    color: AppColor.textWhite,
    letterSpacing: -1.5,
    height: 1,
  );
  static const TextStyle displayMd = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    color: AppColor.textWhite,
    letterSpacing: -1.5,
  );

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColor.textWhite,
    letterSpacing: -0.5,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColor.textWhite,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColor.textWhite,
    letterSpacing: -0.3,
  );
  static const TextStyle h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.textWhite,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColor.textWhite,
  );
  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColor.textWhite,
  );
  static const TextStyle bodySm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColor.textWhite,
  );

  // Labels
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColor.textWhite,
  );
  static const TextStyle labelSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColor.textWhite,
  );

  // Micro badge ("YOUR ANSWER", "LIVE")
  static const TextStyle micro = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColor.black,
    letterSpacing: 0.4,
  );

  // Muted
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColor.textGrey,
    height: 1.5,
  );
  static const TextStyle captionSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.textGrey,
    height: 1.4,
  );
  static const TextStyle hint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColor.textMuted,
    letterSpacing: 0.3,
  );

  // Numbers
  static const TextStyle points = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColor.textWhite,
  );
  static const TextStyle pointsSm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColor.textWhite,
  );

  // Helpers
  static TextStyle colored(TextStyle style, Color color) =>
      style.copyWith(color: color);
  static TextStyle sized(TextStyle style, double size) =>
      style.copyWith(fontSize: size);
}

// ════════════════════════════════════════════════════════════
//  AppDeco  —  reusable BoxDecorations & constants
// ════════════════════════════════════════════════════════════
class AppDeco {
  AppDeco._();

  static const double radius = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusSm = 8.0;

  /// Standard dark card with subtle border
  static BoxDecoration get card => BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColor.borderFaint),
      );

  /// Card with slightly stronger border
  static BoxDecoration get cardBold => BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColor.borderLight),
      );

  /// Circle with border — icon containers, avatar rings
  static BoxDecoration get circleBorder => const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColor.borderLight, width: 1.5),
        ),
      );

  /// Rounded square with border — icon boxes
  static BoxDecoration get squareBorder => BoxDecoration(
        borderRadius: BorderRadius.circular(radiusSm),
        border: Border.all(color: AppColor.borderLight, width: 1.5),
      );

  /// Inline border only — no fill
  static BoxDecoration borderOnly({double r = radius}) => BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: AppColor.borderLight),
      );
}
