import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/legal_controller.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final LegalController controller = Get.put(LegalController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: "About Us"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth < 400 ? 16 : 24;
          double fontSize = constraints.maxWidth < 400 ? 14 : 15;
          double titleFont = fontSize + 4;

          return Obx(() {
            if (controller.isAboutLoading.value &&
                controller.aboutContent.value.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (controller.aboutContent.value.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 56,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "About Us information not available",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: controller.fetchAboutUs,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final content = controller.aboutContent.value;

            return RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
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
                        // Page Title & Subtitle
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
                            color: Theme.of(context).colorScheme.surface,
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
                        _buildStatsRow(controller, context),

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

  Widget _buildStatsRow(LegalController controller, BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

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
              child: _statCard(
                icon: icon,
                label: label,
                value: value,
                context: context,
                primaryColor: primaryColor,
              ),
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
          context: context,
          primaryColor: primaryColor,
        ),
        const SizedBox(width: 10),
        _statCard(
          icon: Icons.verified_rounded,
          label: "Trusted",
          value: "Platform",
          context: context,
          primaryColor: primaryColor,
        ),
        const SizedBox(width: 10),
        _statCard(
          icon: Icons.stars_rounded,
          label: "Rewarding",
          value: "Daily",
          context: context,
          primaryColor: primaryColor,
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 22),
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
