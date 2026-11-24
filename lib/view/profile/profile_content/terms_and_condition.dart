import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/legal_controller.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final LegalController controller = Get.put(LegalController());

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: const CustomAppBar(
        title: "Terms & Conditions",
        showBackButton: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth < 400 ? 16 : 24;
          double fontSize = constraints.maxWidth < 400 ? 14 : 15;
          double titleFont = fontSize + 2;

          return SafeArea(
            child: Obx(() {
              if (controller.isTermsLoading.value &&
                  controller.termsContent.value.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchTerms,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(padding),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: controller.termsContent.value.isNotEmpty
                          ? _buildDynamicContent(
                              controller.termsContent.value,
                              controller.termsUpdatedAt.value,
                              fontSize,
                              titleFont,
                            )
                          : _buildFallbackContent(fontSize, titleFont),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildDynamicContent(
    String content,
    String updatedAt,
    double fontSize,
    double titleFont,
  ) {
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
          style: TextStyle(
            fontSize: fontSize,
            height: 1.65,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackContent(double fontSize, double titleFont) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Opinion Easy. By accessing and using our platform, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.\n",
          style: TextStyle(
            fontSize: fontSize,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 18),
        _title("1. Use of Platform", titleFont),
        _body(
          "This platform is intended for sharing opinions, participating in polls, and earning points and rewards. Unauthorized or improper use may result in account suspension or termination.\n\n"
          "You agree to use Opinion Easy only for lawful purposes and in a way that does not infringe the rights of others or disrupt the platform's functionality.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("2. Intellectual Property", titleFont),
        _body(
          "All content on the platform, including text, graphics, logos, and software, is the property of Opinion Easy and protected by intellectual property laws. Unauthorized reproduction or distribution is strictly prohibited.\n\n"
          "The Opinion Easy name, logo, and all related product and service names are trademarks of Opinion Easy. You may not use these trademarks without prior written permission.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("3. Participation and Rewards", titleFont),
        _body(
          "Users may participate in polls, share opinions, and earn points and rewards according to the platform’s rules. Opinion Easy reserves the right to modify, suspend, or discontinue any poll, reward, or points system without prior notice.\n\n"
          "All points and rewards are subject to verification and may be adjusted or revoked in cases of fraud, misuse, or rule violations.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("4. Limitation of Liability", titleFont),
        _body(
          "Opinion Easy shall not be liable for any indirect, incidental, or consequential damages arising from your use of the platform, including loss of points or rewards. We do not guarantee the accuracy of poll results or the outcome of any reward system.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("5. Governing Law", titleFont),
        _body(
          "These terms and conditions are governed by the laws of India. Any disputes will be subject to the exclusive jurisdiction of the courts in the state of Hisar, Haryana, India.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("6. Amendments", titleFont),
        _body(
          "Opinion Easy reserves the right to update or modify these terms and conditions at any time without prior notice. Continued use of the platform constitutes acceptance of the revised terms.\n\n"
          "You are expected to check this page periodically to take notice of any changes, as they are binding on you.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("7. User Accounts", titleFont),
        _body(
          "If you create an account on Opinion Easy, you are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("8. Links to Other Websites", titleFont),
        _body(
          "Opinion Easy may contain links to third-party websites or services. We do not control these sites and are not responsible for their content, privacy practices, or security. Users are encouraged to review the privacy policies of any external websites.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("9. Termination", titleFont),
        _body(
          "Opinion Easy may suspend or terminate your account or access to the platform at any time, without prior notice or liability, for violations of these Terms, fraudulent activity, or misuse of points and rewards.",
          fontSize,
        ),
        const SizedBox(height: 18),
        _title("10. Contact Information", titleFont),
        _body(
          "If you have any questions about these Terms and Conditions, please contact us at:\n"
          "• Email: info.startup2025@gmail.com\n"
          "• Phone: +91 870 868 0041\n"
          "• Address: WeWork DLF Two Horizon Centre, DLF Phase 5, Sector 43, Golf Course Road, Gurugram, Haryana - 122002",
          fontSize,
        ),
      ],
    );
  }

  Widget _title(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _body(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.6,
        color: Colors.black87,
      ),
    );
  }
}
