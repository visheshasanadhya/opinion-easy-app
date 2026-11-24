import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Backward compatibility alias
typedef ShimmerLeaderboardView = ShimmerTopPerformerView;

class ShimmerTopPerformerView extends StatelessWidget {
  const ShimmerTopPerformerView({super.key});

  final double fixedPadding = 20.0;
  final double fixedGap = 20.0;
  final double podiumSize1 = 95.0;
  final double podiumSize2 = 75.0;
  final double podiumSize3 = 75.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShimmerHero(context),
        Expanded(child: _buildShimmerList(context)),
      ],
    );
  }

  Widget _buildShimmerHero(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: fixedPadding, vertical: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Column(
          children: [
            // Top 3 Avatars Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _PodiumPlaceholder(size: podiumSize2, rank: 2),
                SizedBox(width: fixedGap),
                _PodiumPlaceholder(size: podiumSize1, rank: 1, isPrimary: true),
                SizedBox(width: fixedGap),
                _PodiumPlaceholder(size: podiumSize3, rank: 3),
              ],
            ),
            const SizedBox(height: 20),
            // Podium Blocks
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumBlockPlaceholder(60),
                const SizedBox(width: 10),
                _buildPodiumBlockPlaceholder(85),
                const SizedBox(width: 10),
                _buildPodiumBlockPlaceholder(50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumBlockPlaceholder(double height) {
    return Container(
      height: height,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(
            fixedPadding,
            28,
            fixedPadding,
            100 + MediaQuery.of(context).padding.bottom,
          ),
          itemCount: 8,
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.06),
            height: 1,
            thickness: 1,
            indent: 64,
          ),
          itemBuilder: (context, index) => const _ListItemPlaceholder(),
        ),
      ),
    );
  }
}

class _PodiumPlaceholder extends StatelessWidget {
  final double size;
  final int rank;
  final bool isPrimary;

  const _PodiumPlaceholder({
    required this.size,
    required this.rank,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Crown icon placeholder for 1st place
        if (isPrimary)
          Container(
            height: 32,
            width: 32,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

        // Avatar with rank badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 3.5,
                ),
              ),
            ),
            Positioned(
              bottom: -8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0A0A0A),
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Name placeholder
        Container(
          height: 14,
          width: size * 0.8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),

        // Points placeholder
        Container(
          height: 24,
          width: size * 0.7,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ListItemPlaceholder extends StatelessWidget {
  const _ListItemPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        children: [
          // Rank badge placeholder
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 14),

          // Avatar placeholder
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name placeholder
          Expanded(
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Points badge placeholder
          Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
