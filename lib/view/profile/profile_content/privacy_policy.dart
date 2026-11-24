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
              child: CircularProgressIndicator(
                color: AppColor.primaryColor1,
              ),
            );
          }

          if (controller.privacyContent.value.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.privacy_tip_outlined,
                      size: 56,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Privacy Policy not available",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: controller.fetchPrivacy,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor1,
                        foregroundColor: Colors.white,
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

          return RefreshIndicator(
            color: AppColor.primaryColor1,
            onRefresh: controller.fetchPrivacy,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: _buildDynamicContent(
                controller.privacyContent.value,
                controller.privacyUpdatedAt.value,
              ),
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
}
