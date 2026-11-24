import 'package:flutter/material.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

// ── Drop-in Poll Result Card ────────────────────────────────────────────────

class PollResultWidget extends StatefulWidget {
  final int yesCount;
  final int noCount;
  final double? yesPercentage;
  final double? noPercentage;
  final String? winChoice;
  final String? title;
  final EdgeInsetsGeometry? margin;

  const PollResultWidget({
    super.key,
    required this.yesCount,
    required this.noCount,
    this.yesPercentage,
    this.noPercentage,
    this.winChoice,
    this.title,
    this.margin,
  });

  @override
  State<PollResultWidget> createState() => _PollResultWidgetState();
}

class _PollResultWidgetState extends State<PollResultWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  int get _total => widget.yesCount + widget.noCount;

  // Win / Lose ratios for progress bar (0.0 to 1.0)
  double get _yesRatio {
    if (widget.yesPercentage != null) {
      return (widget.yesPercentage! / 100.0).clamp(0.0, 1.0);
    }
    return _total == 0 ? 0.0 : (widget.yesCount / _total);
  }

  double get _noRatio {
    if (widget.noPercentage != null) {
      return (widget.noPercentage! / 100.0).clamp(0.0, 1.0);
    }
    return _total == 0 ? 0.0 : (widget.noCount / _total);
  }

  int get _yesPercent =>
      widget.yesPercentage?.round() ?? (_yesRatio * 100).round();
  int get _noPercent =>
      widget.noPercentage?.round() ??
      (_total == 0 ? 0 : (100 - _yesPercent));

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    );
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant PollResultWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.yesCount != widget.yesCount ||
        oldWidget.noCount != widget.noCount ||
        oldWidget.yesPercentage != widget.yesPercentage ||
        oldWidget.noPercentage != widget.noPercentage) {
      _ctrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: widget.margin,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(AppDeco.radiusLg),
        border: Border.all(color: AppColor.borderFaint),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header Row ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColor.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderFaint),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 18,
                  color: AppColor.textGrey,
                ),
              ),
              HS(10),
              Text(
                widget.title ?? 'Poll Results',
                style: AppText.bodySm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColor.cardAlt,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.how_to_vote_outlined,
                      size: 13,
                      color: AppColor.textGrey,
                    ),
                    HS(5),
                    Text(
                      _total == 0
                          ? '0 votes'
                          : '$_total ${_total == 1 ? 'vote' : 'votes'}',
                      style: AppText.captionSm.copyWith(
                        color: AppColor.textGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          VS(16),

          // ── Dual Segmented Animated Progress Bar ─────────────────────
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              final progress = _anim.value;
              final curYesFactor = (_yesRatio * progress).clamp(0.0, 1.0);
              final curNoFactor = (_noRatio * progress).clamp(0.0, 1.0);

              return ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.cardAlt,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColor.borderFaint),
                  ),
                  child: _total == 0
                      ? Center(
                          child: Text(
                            'No votes recorded yet',
                            style: AppText.captionSm.copyWith(
                              fontSize: 9,
                              color: AppColor.textMuted,
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            // Left YES bar (Green)
                            if (curYesFactor > 0)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: curYesFactor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.green,
                                      borderRadius: BorderRadius.horizontal(
                                        left: const Radius.circular(100),
                                        right: Radius.circular(
                                          _noRatio == 0 ? 100 : 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Right NO bar (Red)
                            if (curNoFactor > 0)
                              Align(
                                alignment: Alignment.centerRight,
                                child: FractionallySizedBox(
                                  widthFactor: curNoFactor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.red,
                                      borderRadius: BorderRadius.horizontal(
                                        right: const Radius.circular(100),
                                        left: Radius.circular(
                                          _yesRatio == 0 ? 100 : 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              );
            },
          ),

          VS(14),

          // ── Stat Cards (YES / NO) ────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _VoteCard(
                  isYes: true,
                  percent: _yesPercent,
                  count: widget.yesCount,
                ),
              ),
              HS(12),
              Expanded(
                child: _VoteCard(
                  isYes: false,
                  percent: _noPercent,
                  count: widget.noCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Internal Vote Stat Card Widget ──────────────────────────────────────────

class _VoteCard extends StatelessWidget {
  final bool isYes;
  final int percent;
  final int count;

  const _VoteCard({
    required this.isYes,
    required this.percent,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final Color themeColor = isYes ? AppColor.green : AppColor.red;
    final IconData icon =
        isYes ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final String label = isYes ? 'YES' : 'NO';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.cardAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isYes ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment:
                isYes ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isYes) ...[
                Icon(icon, size: 16, color: themeColor),
                HS(6),
              ],
              Text(
                label,
                style: AppText.labelSm.copyWith(
                  color: themeColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              if (!isYes) ...[
                HS(6),
                Icon(icon, size: 16, color: themeColor),
              ],
            ],
          ),
          VS(6),
          Text(
            '$percent%',
            style: AppText.h2.copyWith(
              color: themeColor,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          VS(2),
          Text(
            '$count ${count == 1 ? 'vote' : 'votes'}',
            style: AppText.captionSm.copyWith(
              color: AppColor.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
