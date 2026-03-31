import 'package:flutter/material.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: CustomAppBar(title: "Privacy Policy", showBackButton: true),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "At Daily Opinion, we are committed to protecting your privacy and ensuring the security of your personal information. "
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
              "• Provide and manage the Daily Opinion platform and its features\n"
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
              "By using Daily Opinion, you consent to our use of cookies as described here.\n",
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
              "You have the right to:\n"
              "• Access the personal information we hold about you\n"
              "• Update or correct inaccurate information\n"
              "• Delete your personal information, subject to legal obligations\n"
              "• Object to or restrict certain processing activities\n"
              "• Receive your data in a portable format\n\n"
              "To exercise these rights, please contact us at info.startup2025@gmail.com. "
              "We will respond to your request within 30 days.\n",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "6. Data Retention",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "We retain your personal information only for as long as necessary to operate Daily Opinion, manage accounts, and process rewards, "
              "unless a longer retention period is required by law.\n\n"
              "Factors considered include:\n"
              "• Your account activity and engagement\n"
              "• Legal obligations\n"
              "• Operational needs and system maintenance\n",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "7. Policy Updates",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "We may update this Privacy Policy to reflect changes in our practices or legal requirements. "
              "Updates will be posted on this page, and continued use of the platform constitutes acceptance of the revised policy.\n\n"
              "We will notify users of material changes via in-app notices or email when appropriate.\n",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "8. Contact Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "If you have questions or concerns about this Privacy Policy or our data practices, please contact us:\n\n"
              "Email: info.startup2025@gmail.com\n"
              "Phone: +91 870 868 0041\n"
              "Address: Hisar, Haryana, India\n\n"
              "We take privacy seriously and will respond promptly to your inquiries.\n\n"
              "Last updated: October 13, 2025\n\n"
              "We encourage you to review this policy regularly to stay informed about how we protect your information while using Daily Opinion.",
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
