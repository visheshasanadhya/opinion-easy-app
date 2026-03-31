import 'package:opinion_easy/core/utils/app_constants.dart';

import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';

class WatchLiveCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final IconData icon;
  final List<Color> gradientColors;
  final Color liveColor;

  const WatchLiveCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.icon,
    required this.gradientColors,
    required this.liveColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = AppColor.blackColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            gradientColors.first.withOpacity(0.15),
            gradientColors.last.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          width: 2.5,
          color: gradientColors.last.withOpacity(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: gradientColors.last.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gradientColors.first.withOpacity(0.6),
                    //     blurRadius: 12,
                    //     spreadRadius: 2,
                    //   ),
                    // ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      VS(4),
                      Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                BlinkingLiveIndicator(liveColor: liveColor),
                const SizedBox(width: 15),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlinkingLiveIndicator extends StatefulWidget {
  final Color liveColor;

  const BlinkingLiveIndicator({super.key, required this.liveColor});

  @override
  State<BlinkingLiveIndicator> createState() => _BlinkingLiveIndicatorState();
}

class _BlinkingLiveIndicatorState extends State<BlinkingLiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        'LIVE',
        style: TextStyle(
          color: widget.liveColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: widget.liveColor.withOpacity(0.7), blurRadius: 5),
          ],
        ),
      ),
    );
  }
}
