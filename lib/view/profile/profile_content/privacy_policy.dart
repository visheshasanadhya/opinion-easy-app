import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/legal_controller.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final LegalController controller = Get.put(LegalController());

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: const CustomAppBar(
        title: "Privacy Policy",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isPrivacyLoading.value &&
              controller.privacyContent.value.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchPrivacy,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: controller.privacyContent.value.isNotEmpty
                  ? _buildDynamicContent(
                      controller.privacyContent.value,
                      controller.privacyUpdatedAt.value,
                    )
                  : _buildFallbackContent(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDynamicContent(String content, String updatedAt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (updatedAt.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              "Last updated: $updatedAt",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SelectableText(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.65,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "At Opinion Easy, we are committed to protecting your privacy and ensuring the security of your personal information. "
          "This Privacy Policy explains how we collect, use, and safeguard your data when you use our platform to share opinions, earn points, and redeem rewards.\n",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "1. Information Collection",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "We may collect personal information such as your name, email address, and phone number when you sign up or participate in polls.\n\n"
          "We also collect non-personal information, such as device type, browser type, and IP address, for analytical purposes and to improve the app experience.\n\n"
          "Types of information we collect include:\n"
          "• Contact information (name, email, phone number)\n"
          "• Account activity (poll participation, points earned, rewards redeemed)\n"
          "• Technical information (IP address, browser type, device information)\n"
          "• Usage data (pages visited, features used, app interactions)\n",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "2. Use of Information",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "Your information is used to:\n"
          "• Provide and manage the Opinion Easy platform and its features\n"
          "• Process points and rewards earned through participation\n"
          "• Communicate updates, new polls, promotional offers, and service alerts\n"
          "• Improve the platform experience and ensure fair participation\n"
          "• Analyze usage patterns to enhance features and engagement\n\n"
          "We do not sell, trade, or share your personal information with third parties without consent, "
          "except as required by law or to operate our platform (e.g., processing rewards through third-party payment services).\n",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "3. Data Security",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "We implement industry-standard security measures to protect your data from unauthorized access, alteration, or disclosure. "
          "These include encryption of sensitive data, secure server infrastructure, regular security assessments, "
          "and access controls with authentication protocols.\n\n"
          "While we strive to protect your data, no system is completely secure. "
          "We encourage you to take precautions to protect your account and personal information.\n",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "4. Cookies",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "Our website and app may use cookies to enhance your experience. Cookies help us:\n"
          "• Remember your login and preferences\n"
          "• Analyze how users interact with the platform\n"
          "• Personalize your experience and recommend polls\n"
          "• Improve features and overall app performance\n\n"
          "You can disable cookies in your browser settings, but this may affect functionality. "
          "By using Opinion Easy, you consent to our use of cookies as described here.\n",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "5. Your Rights",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "You have the right to access, update, or delete your personal information. "
          "To exercise these rights, please contact us at info.startup2025@gmail.com.\n",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "6. Contact Information",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "If you have questions about this Privacy Policy, please contact us at:\n"
          "• Email: info.startup2025@gmail.com\n"
          "• Phone: +91 870 868 0041\n"
          "• Address: WeWork DLF Two Horizon Centre, DLF Phase 5, Sector 43, Golf Course Road, Gurugram, Haryana - 122002",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
