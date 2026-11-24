import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/legal_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
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
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(title: "Help & Support"),
      body: Obx(() {
        if (controller.isHelpLoading.value &&
            controller.helpEmail.value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primaryColor1),
          );
        }

        return RefreshIndicator(
          color: AppColor.primaryColor1,
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
                  style: AppText.h2,
                ),
                VS(12),

                // Description
                Text(
                  controller.helpDescription.value,
                  style: AppText.caption,
                ),

                if (controller.helpSubDescription.value.isNotEmpty) ...[
                  VS(8),
                  Text(
                    controller.helpSubDescription.value,
                    style: AppText.caption,
                  ),
                ],

                VS(24),

                // Email Card
                if (controller.helpEmail.value.isNotEmpty) ...[
                  _buildContactCard(
                    icon: Icons.email_outlined,
                    title: "Email Support",
                    subtitle: controller.helpEmail.value,
                    color: AppColor.blue,
                    onTap: () => _launchEmail(controller.helpEmail.value),
                  ),
                  VS(14),
                ],

                // Phone Card
                if (controller.helpPhone.value.isNotEmpty) ...[
                  _buildContactCard(
                    icon: Icons.phone_outlined,
                    title: "Call Us",
                    subtitle: controller.helpPhone.value,
                    color: AppColor.green,
                    onTap: () => _launchPhone(controller.helpPhone.value),
                  ),
                  VS(14),
                ],

                // WhatsApp Card
                if (controller.helpWhatsapp.value.isNotEmpty) ...[
                  _buildContactCard(
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
                    icon: Icons.access_time_rounded,
                    title: "Working Hours",
                    subtitle: controller.helpAvailability.value,
                    color: AppColor.orange,
                    onTap: () {},
                    isClickable: false,
                  ),
                  VS(14),
                ],

                // Office Address Card
                if (controller.helpAddress.value.isNotEmpty) ...[
                  _buildContactCard(
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
                      style: AppText.captionSm,
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
        decoration: AppDeco.card,
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
                  Text(title, style: AppText.bodyMd),
                  VS(4),
                  Text(subtitle, style: AppText.captionSm),
                ],
              ),
            ),
            if (isClickable)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColor.textGrey,
              ),
          ],
        ),
      ),
    );
  }
}
