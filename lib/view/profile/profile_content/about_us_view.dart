import 'package:opinion_easy/core/utils/app_constants.dart';

import 'package:flutter/material.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: const CustomAppBar(title: "About Us"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth < 400 ? 16 : 24;
          double fontSize = constraints.maxWidth < 400 ? 14 : 15;
          double titleFont = fontSize + 3;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor1.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColor.primaryColor1.withOpacity(0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: AppColor.primaryColor1,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "About Opinion Easy",
                            style: TextStyle(
                              fontSize: titleFont + 2,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your voice. Your rewards.",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Content card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Text(
                        "At Opinion Easy, we aim to transform the way people express their thoughts by offering a simple, engaging, and technology-driven platform for sharing daily opinions.\n\n"
                        "Our mission is to empower users with smart opinion-sharing features, transparent results, and a rewarding point system that makes participation both exciting and meaningful. Every day, users engage with thought-provoking questions and earn points for their \"Yes\" or winning opinions, turning everyday interactions into valuable rewards.\n\n"
                        "When a user's opinion aligns with the most popular public response, they earn bonus points and exclusive rewards. This system encourages healthy participation, fair competition, and keeps the community active and motivated.\n\n"
                        "Over time, we have built a strong and vibrant community where thousands of opinions are shared daily. The platform encourages open expression and insightful discussions that reflect real public perspectives across various topics.\n\n"
                        "We take pride in our secure systems, reliable performance, and fair rewarding process—ensuring transparency and trust for every user. Our commitment to authenticity and user satisfaction has helped Daily Opinion become one of the most trusted platforms for expressing views online.\n\n"
                        "At Opinion Easy, we combine innovation, simplicity, and user-first values to create a seamless experience where sharing opinions is effortless and rewarding. We continue to set new standards in how people interact, express themselves, and get recognized — because here, every opinion truly matters.",
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.7,
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats row
                    Row(
                      children: [
                        _statCard(
                          icon: Icons.people_alt_rounded,
                          label: "Community",
                          value: "Thousands",
                        ),
                        const SizedBox(width: 12),
                        _statCard(
                          icon: Icons.verified_rounded,
                          label: "Trusted",
                          value: "Platform",
                        ),
                        const SizedBox(width: 12),
                        _statCard(
                          icon: Icons.stars_rounded,
                          label: "Rewarding",
                          value: "Daily",
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColor.primaryColor1, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
