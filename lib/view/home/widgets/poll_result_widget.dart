import 'package:flutter/material.dart';

// ── Drop-in poll result card ───────────────────────────────────────────────

class PollResultWidget extends StatefulWidget {
  final int yesCount;
  final int noCount;

  const PollResultWidget({
    super.key,
    required this.yesCount,
    required this.noCount,
  });

  @override
  State<PollResultWidget> createState() => _PollResultWidgetState();
}

class _PollResultWidgetState extends State<PollResultWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _yesFill;

  double get _total => (widget.yesCount + widget.noCount).toDouble();
  double get _yesPct => _total == 0 ? 0 : widget.yesCount / _total;
  double get _noPct => _total == 0 ? 0 : widget.noCount / _total;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _yesFill = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int yesPercent = (_yesPct * 100).round();
    final int noPercent = (_noPct * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 16,
                color: Color(0xFF9E9E9E),
              ),
              const SizedBox(width: 6),
              Text(
                'Poll Results',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.yesCount + widget.noCount} votes',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Progress bar ───────────────────────────────────
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Stack(
                  children: [
                    // Background (NO side)
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: const Color(0xFFE53935).withValues(alpha: 0.25),
                    ),
                    // YES fill
                    FractionallySizedBox(
                      widthFactor: _yesFill.value * _yesPct,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43A047),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // ── Yes / No labels ────────────────────────────────
          Row(
            children: [
              // YES
              Expanded(
                child: _VoteLabel(
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF43A047),
                  label: 'YES',
                  percent: yesPercent,
                  count: widget.yesCount,
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              // NO
              Expanded(
                child: _VoteLabel(
                  icon: Icons.cancel_rounded,
                  color: const Color(0xFFE53935),
                  label: 'NO',
                  percent: noPercent,
                  count: widget.noCount,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Internal label widget ──────────────────────────────────────────────────
class _VoteLabel extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int percent;
  final int count;
  final CrossAxisAlignment alignment;

  const _VoteLabel({
    required this.icon,
    required this.color,
    required this.label,
    required this.percent,
    required this.count,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = alignment == CrossAxisAlignment.end;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisAlignment:
              isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isRight) ...[
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
            if (isRight) ...[
              const SizedBox(width: 5),
              Icon(icon, size: 15, color: color),
            ],
          ],
        ),
        const SizedBox(height: 3),
        Text(
          '$percent%',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          '$count votes',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}
