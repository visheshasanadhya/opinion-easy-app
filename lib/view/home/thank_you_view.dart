// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:opinion_easy/controller/category_controller.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:opinion_easy/view/home/sub_categ_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';

class ThankYouView extends StatefulWidget {
  const ThankYouView({super.key});

  @override
  State<ThankYouView> createState() => _ThankYouViewState();
}

class _ThankYouViewState extends State<ThankYouView> {
  late final ProfileController profileController;
  late final CategoryController categoryController;

  @override
  void initState() {
    super.initState();
    // Use find only — these are already registered upstream
    profileController = Get.find<ProfileController>();
    categoryController = Get.find<CategoryController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            decoration: AppDeco.card,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColor.green.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.green.withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 40,
                    color: AppColor.green,
                  ),
                ),
                VS(16),
                Text("Thank You!", style: AppText.h2),
                VS(10),
                Text(
                  "Your answers were submitted\nsuccessfully.",
                  textAlign: TextAlign.center,
                  style: AppText.caption,
                ),
                VS(24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.white,
                      foregroundColor: AppColor.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDeco.radius),
                      ),
                    ),
                    onPressed: () {
                      // Refresh profile points in background
                      profileController.fetchProfile();

                      // Navigate back to SubCategView — its initState will
                      // call fetchSubCateg automatically, so no need to
                      // call it here. offUntil pops everything above the
                      // first route and pushes SubCategView fresh.
                      Get.offUntil(
                        GetPageRoute(page: () => const SubCategView()),
                        (route) => route.isFirst,
                      );
                    },
                    child: Text(
                      "Take Another Survey",
                      style: AppText.bodyMd.copyWith(color: AppColor.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
