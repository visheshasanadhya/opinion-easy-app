import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/core/utils/widgets/custom_app_bar.dart';
import 'package:opinion_easy/core/utils/widgets/custom_text_field.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

class CompleteProfileView extends StatelessWidget {
  final ProfileController profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  CompleteProfileView({super.key});

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppText.hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = profileController;
    controller.ensureControllersActive();

    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: CustomAppBar(
        title: "Complete Profile",
        showBackButton: false,
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed('/bottom-nav'),
            child: Text(
              "Skip",
              style: AppText.bodySm.copyWith(
                color: AppColor.textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          HS(8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: controller.profileKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Just a few details to finish setting up your account.",
                  style: AppText.caption,
                ),
                VS(24),

                // ── Profile Picture Avatar ───────────────
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        final imageUrl = controller.profile.value?.profilePic;
                        final imageFile = controller.selectedImage.value;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.borderStrong,
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: AppColor.cardAlt,
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile) as ImageProvider
                                : imageUrl != null && imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : null,
                            child: (imageFile == null &&
                                    (imageUrl == null || imageUrl.isEmpty))
                                ? const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: AppColor.textGrey,
                                  )
                                : null,
                          ),
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.showImageSourceDialog,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.scaffold,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 16,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VS(28),

                // ── Name ────────────────────────────────
                CustomTextField(
                  title: "Full Name",
                  controller: controller.nameController,
                  hintText: "e.g. Vishesh Sanadhya",
                  keyboardType: TextInputType.name,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                VS(16),

                // ── Phone ────────────────────────────────
                CustomTextField(
                  title: "Phone Number",
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  hintText: "Enter 10-digit number",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          color: AppColor.white,
                          size: 18,
                        ),
                        HS(6),
                        Text("+91 ", style: AppText.bodyMd),
                      ],
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                VS(16),

                // ── Email (Fixed from Google account) ────
                CustomTextField(
                  title: "Email Address",
                  controller: controller.emailController,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "example@gmail.com",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColor.textGrey,
                      size: 18,
                    ),
                  ),
                ),
                VS(16),

                // ── Date of Birth ────────────────────────
                _label("Date of Birth"),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColor.white,
                            onPrimary: AppColor.black,
                            surface: AppColor.card,
                            onSurface: AppColor.white,
                          ),
                          dialogTheme: const DialogThemeData(
                            backgroundColor: AppColor.card,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      controller.selectedDob.value =
                          DateFormat('dd-MM-yyyy').format(picked);
                    }
                  },
                  child: Obx(
                    () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.cardAlt,
                        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
                        border: Border.all(
                          color: AppColor.borderLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppColor.textGrey,
                          ),
                          HS(10),
                          Text(
                            controller.selectedDob.value.isEmpty
                                ? "Select Date of Birth"
                                : controller.selectedDob.value,
                            style: AppText.bodyMd.copyWith(
                              color: controller.selectedDob.value.isEmpty
                                  ? AppColor.textGrey
                                  : AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                VS(16),

                // ── Address ───────────────────────────────
                CustomTextField(
                  title: "Address",
                  controller: controller.addressController,
                  maxLines: 2,
                  hintText: "Street, locality, area details",
                  keyboardType: TextInputType.streetAddress,
                ),
                VS(16),

                // ── Pincode (Auto-fetches City & State) ──
                Obx(
                  () => CustomTextField(
                    title: "Pincode",
                    controller: controller.pincodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    hintText: "Enter 6-digit pincode",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppColor.white,
                        size: 20,
                      ),
                    ),
                    suffixIcon: controller.isVerifyingPincode.value
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.white,
                              ),
                            ),
                          )
                        : controller.isPincodeValid.value
                            ? const Padding(
                                padding: EdgeInsets.all(14),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColor.green,
                                  size: 20,
                                ),
                              )
                            : null,
                    validator: (v) {
                      if (v != null && v.isNotEmpty && v.length < 6) {
                        return 'Enter 6-digit pincode';
                      }
                      return null;
                    },
                  ),
                ),
                VS(16),

                // ── State & City (Auto-populated from Pincode) ──
                Obx(() {
                  if (controller.isPincodeValid.value ||
                      controller.stateController.text.isNotEmpty ||
                      controller.cityController.text.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                title: "City",
                                controller: controller.cityController,
                                readOnly: true,
                                hintText: "City",
                              ),
                            ),
                            HS(12),
                            Expanded(
                              child: CustomTextField(
                                title: "State",
                                controller: controller.stateController,
                                readOnly: true,
                                hintText: "State",
                              ),
                            ),
                          ],
                        ),
                        VS(16),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // ── Referral Code (Optional) ────────────
                CustomTextField(
                  title: "Referral Code",
                  controller: controller.referralController,
                  textCapitalization: TextCapitalization.characters,
                  hintText: "Enter Referral Code (optional)",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      Icons.card_giftcard_outlined,
                      color: AppColor.white,
                      size: 20,
                    ),
                  ),
                ),
                VS(6),
                Text(
                  "Enter friend's code to get 500 bonus points on signup.",
                  style: AppText.captionSm.copyWith(
                    color: AppColor.textGrey,
                  ),
                ),
                VS(32),

                // ── Complete Profile Button ───────────────
                Obx(
                  () => PrimaryBtnWidget(
                    name: controller.isLoading.value
                        ? "Saving..."
                        : "Complete Registration",
                    onTap: () async {
                      await controller.updateProfile(
                        navigateHomeOnSuccess: true,
                      );
                    },
                  ),
                ),
                VS(16),

                // ── Skip Option ───────────────────────────
                Center(
                  child: TextButton(
                    onPressed: () => Get.offAllNamed('/bottom-nav'),
                    child: Text(
                      "I'll complete this later",
                      style: AppText.captionSm.copyWith(
                        color: AppColor.textGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                VS(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
