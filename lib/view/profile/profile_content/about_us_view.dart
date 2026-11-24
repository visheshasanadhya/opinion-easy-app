import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/legal_controller.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  static const String _fallbackContent =
      "At Opinion Easy, we aim to transform the way people express their thoughts by offering a simple, engaging, and technology-driven platform for sharing daily opinions.\n\n"
      "Our mission is to empower users with smart opinion-sharing features, transparent results, and a rewarding point system that makes participation both exciting and meaningful. Every day, thousands of users engage with thought-provoking questions, expressing their perspectives and turning everyday interactions into valuable rewards.\n\n"
      "When your opinion aligns with the most popular public outcome, you earn points and redeem exclusive rewards, vouchers, and cash payouts. This system encourages healthy participation, fair competition, and keeps our vibrant community active and motivated.\n\n"
      "Over time, we have built a strong and vibrant community where opinions are shared daily across cricket, entertainment, politics, technology, and trending news.\n\n"
      "We take immense pride in our secure systems, verified payouts, and reliable performance—ensuring complete transparency and trust. At Opinion Easy, every opinion truly matters.";

  @override
  Widget build(BuildContext context) {
    final LegalController controller = Get.put(LegalController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: const CustomAppBar(title: "About Us"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth < 400 ? 16 : 24;
          double fontSize = constraints.maxWidth < 400 ? 14 : 15;
          double titleFont = fontSize + 4;

          return Obx(() {
            if (controller.isAboutLoading.value &&
                controller.aboutContent.value.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor1,
                ),
              );
            }

            final content = controller.aboutContent.value.isNotEmpty
                ? controller.aboutContent.value
                : _fallbackContent;

            return RefreshIndicator(
              color: AppColor.primaryColor1,
              onRefresh: controller.fetchAboutUs,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(padding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Title & Subtitle (No gradient header box)
                        Text(
                          controller.aboutTitle.value,
                          style: TextStyle(
                            fontSize: titleFont + 4,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (controller.aboutSubtitle.value.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            controller.aboutSubtitle.value,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        if (controller.aboutUpdatedAt.value.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Text(
                              "Last updated: ${controller.aboutUpdatedAt.value}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Content card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141414),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: SelectableText(
                            content,
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
                        _buildStatsRow(controller),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildStatsRow(LegalController controller) {
    if (controller.aboutStats.isNotEmpty) {
      return Row(
        children: controller.aboutStats.map((stat) {
          final label = stat['label']?.toString() ?? '';
          final value = stat['value']?.toString() ?? '';
          final iconName = stat['icon']?.toString() ?? '';
          IconData icon = Icons.stars_rounded;
          if (iconName == 'people') {
            icon = Icons.people_alt_rounded;
          } else if (iconName == 'verified') {
            icon = Icons.verified_rounded;
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _statCard(icon: icon, label: label, value: value),
            ),
          );
        }).toList(),
      );
    }

    return Row(
      children: [
        _statCard(
          icon: Icons.people_alt_rounded,
          label: "Community",
          value: "Thousands",
        ),
        const SizedBox(width: 10),
        _statCard(
          icon: Icons.verified_rounded,
          label: "Trusted",
          value: "Platform",
        ),
        const SizedBox(width: 10),
        _statCard(
          icon: Icons.stars_rounded,
          label: "Rewarding",
          value: "Daily",
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
