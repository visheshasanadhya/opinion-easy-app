import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  void _launchPhone(String number) async {
    await launchUrl(Uri(scheme: 'tel', path: number));
  }

  void _launchEmail(String email) async {
    await launchUrl(Uri(scheme: 'mailto', path: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(title: "Help & Support"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Our Support Team", style: AppText.h2),
            VS(14),
            Text(
              "Welcome to the Help & Support Center for Daily Opinion. We're here to assist you with any questions, issues, or feedback.",
              style: AppText.caption,
            ),
            VS(10),
            Text(
              "Reach out using the options below and we'll respond soon.",
              style: AppText.caption,
            ),
            VS(28),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: "Email",
              subtitle: "opinioneasy2026@gmail.com",
              color: AppColor.blue,
              onTap: () => _launchEmail("opinioneasy2026@gmail.com"),
            ),
            VS(14),
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: "Phone",
              subtitle: "+91 8941003522",
              color: AppColor.green,
              onTap: () => _launchPhone("8941003522"),
            ),
            VS(14),
            _buildContactCard(
              icon: Icons.access_time_rounded,
              title: "Availability",
              subtitle: "9:00 AM - 6:00 PM IST\nMonday - Sunday",
              color: AppColor.orange,
              onTap: () {},
              isClickable: false,
            ),
            VS(36),
            Center(
              child: Text(
                "We value your feedback — helping us improve\nyour experience every day.",
                textAlign: TextAlign.center,
                style: AppText.captionSm,
              ),
            ),
            VS(16),
          ],
        ),
      ),
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
