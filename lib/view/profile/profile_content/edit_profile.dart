import 'package:flutter/services.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  EditProfileView({super.key});

  // ── Dark-themed input decoration ──────────────────────────
  InputDecoration _inputDecoration(
    String hint, {
    Widget? prefix,
    Widget? suffix,
  }) {
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
      suffixIcon: suffix,
      suffixIconConstraints: suffix != null
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
        borderSide: const BorderSide(color: AppColor.blue, width: 1.5),
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

  // ── Section label ─────────────────────────────────────────
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
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.scaffold,
      appBar: AppBar(
        backgroundColor: AppColor.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Personal Details", style: AppText.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColor.borderFaint),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: controller.profileKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ──────────────────────────────
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final imageUrl = controller.profile.value?.profilePic;
                          final imageFile = controller.selectedImage.value;
                          if (imageUrl == null && imageFile == null) return;
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: AppColor.black,
                              child: InteractiveViewer(
                                child: imageFile != null
                                    ? Image.file(imageFile, fit: BoxFit.contain)
                                    : Image.network(
                                        imageUrl!,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          );
                        },
                        child: Obx(() {
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
                              radius: 52,
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
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: controller.showImageSourceDialog,
                          child: Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: AppColor.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.scaffold,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 17,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VS(32),

                // ── Name ────────────────────────────────
                _label("Name"),
                TextFormField(
                  controller: controller.nameController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration("e.g. Raj Kumar"),
                  keyboardType: TextInputType.name,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                VS(16),

                // ── Phone ────────────────────────────────
                _label("Phone Number"),
                TextFormField(
                  controller: controller.phoneController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration("+91 9XXXXXXXXX"),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Phone number is required';
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                      return 'Enter a valid 10-digit phone number';
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
                            primary: AppColor.blue,
                            surface: AppColor.card,
                            onSurface: AppColor.white,
                          ),
                          dialogBackgroundColor: AppColor.card,
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      controller.selectedDob.value = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked);
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

                // ── Email ─────────────────────────────────
                _label("Email Address"),
                TextFormField(
                  controller: controller.emailController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration("example@email.com"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(v)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                VS(16),

                // ── Address ───────────────────────────────
                _label("Address"),
                TextFormField(
                  maxLines: 2,
                  controller: controller.addressController,
                  style: AppText.bodyMd,
                  decoration: _inputDecoration(
                    "23/234, Soft Link Road, Sec-32, 112345",
                  ),
                  keyboardType: TextInputType.streetAddress,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Address is required' : null,
                ),
                VS(16),

                // ── Pincode (Auto-fetches City & State) ──
                _label("Pincode"),
                Obx(
                  () => TextFormField(
                    controller: controller.pincodeController,
                    style: AppText.bodyMd,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: _inputDecoration(
                      "Enter 6-digit pincode",
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: AppColor.white,
                          size: 20,
                        ),
                      ),
                      suffix: controller.isVerifyingPincode.value
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
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Pincode is required';
                      if (!RegExp(r'^\d{6}$').hasMatch(v)) {
                        return 'Invalid 6-digit pincode';
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label("City"),
                                  TextFormField(
                                    controller: controller.cityController,
                                    readOnly: true,
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
                                  _label("State"),
                                  TextFormField(
                                    controller: controller.stateController,
                                    readOnly: true,
                                    style: AppText.bodyMd,
                                    decoration: _inputDecoration("State"),
                                  ),
                                ],
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
                VS(32),

                // ── Save Button ───────────────────────────
                Obx(
                  () => PrimaryBtnWidget(
                    name: controller.isLoading.value
                        ? "Saving..."
                        : "Save Changes",
                    onTap: () async => await controller.updateProfile(),
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
