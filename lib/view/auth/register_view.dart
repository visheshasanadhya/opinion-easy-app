import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

class RegisterView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  RegisterView({super.key});

  InputDecoration _inputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintText: hint,
      hintStyle: AppText.captionSm,
      filled: true,
      fillColor: AppColor.cardAlt,
      prefixIcon: prefix,
      prefixIconConstraints: prefix != null
          ? const BoxConstraints(minWidth: 0, minHeight: 0)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
        borderSide: BorderSide(color: AppColor.borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
        borderSide: BorderSide(color: AppColor.borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
        borderSide: const BorderSide(color: AppColor.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
        borderSide: const BorderSide(color: AppColor.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDeco.radiusSm),
        borderSide: const BorderSide(color: AppColor.red, width: 1.5),
      ),
      errorStyle: const TextStyle(color: AppColor.red),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppText.hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = profileController;

    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: AppBar(
        backgroundColor: AppColor.scaffold,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text("Complete Profile", style: AppText.h3),
        centerTitle: true,
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
                                ? FileImage(imageFile)
                                : imageUrl != null && imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : const AssetImage('assets/images/user.jpg')
                                        as ImageProvider,
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
                _label("Full Name"),
                TextFormField(
                  controller: controller.nameController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration("e.g. Vishesh Sanadhya"),
                  keyboardType: TextInputType.name,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                VS(16),

                // ── Phone ────────────────────────────────
                _label("Phone Number"),
                TextFormField(
                  controller: controller.phoneController,
                  style: AppText.bodyMd,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    "Enter 10-digit number",
                    prefix: Padding(
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
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                VS(16),

                // ── Email ─────────────────────────────────
                _label("Email Address"),
                TextFormField(
                  controller: controller.emailController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration("example@gmail.com"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email is required';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(v.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
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
                          DateFormat('yyyy-MM-dd').format(picked);
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
                _label("Address"),
                TextFormField(
                  maxLines: 2,
                  controller: controller.addressController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration(
                    "Street, locality, area details",
                  ),
                  keyboardType: TextInputType.streetAddress,
                ),
                VS(16),

                // ── State ─────────────────────────────────
                _label("State"),
                Obx(
                  () => DropdownButtonFormField<String>(
                    dropdownColor: AppColor.card,
                    style: AppText.bodyMd,
                    iconEnabledColor: AppColor.textGrey,
                    decoration: _inputDecoration("Select State"),
                    initialValue: controller.selectedState.value.isEmpty
                        ? null
                        : controller.selectedState.value,
                    hint: Text("Select State", style: AppText.captionSm),
                    onChanged: (v) => controller.selectedState.value = v ?? '',
                    items: controller.states
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                  ),
                ),
                VS(16),

                // ── District ──────────────────────────────
                _label("District"),
                TextFormField(
                  controller: controller.districtController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration("Enter District"),
                ),
                VS(16),

                // ── City & Pincode ────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("City"),
                          TextFormField(
                            controller: controller.cityController,
                            style: AppText.bodyMd,
                            decoration: _inputDecoration("City"),
                          ),
                        ],
                      ),
                    ),
                    HS(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Pincode"),
                          TextFormField(
                            controller: controller.pincodeController,
                            style: AppText.bodyMd,
                            decoration: _inputDecoration("6-digit code"),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v != null &&
                                  v.isNotEmpty &&
                                  !RegExp(r'^\d{6}$').hasMatch(v)) {
                                return 'Invalid 6-digit code';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
