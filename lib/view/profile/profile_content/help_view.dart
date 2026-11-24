import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/legal_controller.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  void _launchPhone(String number) async {
    final clean = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchWhatsApp(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchWebsite(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LegalController controller = Get.put(LegalController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: "Help & Support"),
      body: Obx(() {
        if (controller.isHelpLoading.value &&
            controller.helpEmail.value.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        return RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: controller.fetchHelpSupport,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  controller.helpTitle.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                VS(12),

                // Description
                Text(
                  controller.helpDescription.value,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[400],
                  ),
                ),

                if (controller.helpSubDescription.value.isNotEmpty) ...[
                  VS(8),
                  Text(
                    controller.helpSubDescription.value,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.grey[500],
                    ),
                  ),
                ],

                VS(24),

                // Email Card
                if (controller.helpEmail.value.isNotEmpty) ...[
                  _buildContactCard(
                    context: context,
                    icon: Icons.email_outlined,
                    title: "Email Support",
                    subtitle: controller.helpEmail.value,
                    color: const Color(0xFF4A90E2),
                    onTap: () => _launchEmail(controller.helpEmail.value),
                  ),
                  VS(14),
                ],

                // Phone Card
                if (controller.helpPhone.value.isNotEmpty) ...[
                  _buildContactCard(
                    context: context,
                    icon: Icons.phone_outlined,
                    title: "Call Us",
                    subtitle: controller.helpPhone.value,
                    color: const Color(0xFF4CAF50),
                    onTap: () => _launchPhone(controller.helpPhone.value),
                  ),
                  VS(14),
                ],

                // WhatsApp Card
                if (controller.helpWhatsapp.value.isNotEmpty) ...[
                  _buildContactCard(
                    context: context,
                    icon: Icons.chat_bubble_outline_rounded,
                    title: "WhatsApp Chat",
                    subtitle: controller.helpWhatsapp.value,
                    color: const Color(0xFF25D366),
                    onTap: () =>
                        _launchWhatsApp(controller.helpWhatsapp.value),
                  ),
                  VS(14),
                ],

                // Availability Card
                if (controller.helpAvailability.value.isNotEmpty) ...[
                  _buildContactCard(
                    context: context,
                    icon: Icons.access_time_rounded,
                    title: "Working Hours",
                    subtitle: controller.helpAvailability.value,
                    color: const Color(0xFFFF9800),
                    onTap: () {},
                    isClickable: false,
                  ),
                  VS(14),
                ],

                // Office Address Card
                if (controller.helpAddress.value.isNotEmpty) ...[
                  _buildContactCard(
                    context: context,
                    icon: Icons.location_on_outlined,
                    title: "Office Address",
                    subtitle: controller.helpAddress.value,
                    color: Colors.redAccent,
                    onTap: () {},
                    isClickable: false,
                  ),
                  VS(14),
                ],

                // Website Card
                if (controller.helpWebsite.value.isNotEmpty) ...[
                  _buildContactCard(
                    context: context,
                    icon: Icons.language_rounded,
                    title: "Official Website",
                    subtitle: controller.helpWebsite.value,
                    color: Colors.teal,
                    onTap: () => _launchWebsite(controller.helpWebsite.value),
                  ),
                  VS(14),
                ],

                VS(20),

                // Footer Note
                if (controller.helpFooterNote.value.isNotEmpty) ...[
                  Center(
                    child: Text(
                      controller.helpFooterNote.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  VS(16),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isClickable = true,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            HS(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  VS(4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (isClickable)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[500],
              ),
          ],
        ),
      ),
    );
  }
}
