import 'package:flutter/services.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/btn_widget.dart';
import 'package:opinion_easy/controller/profile_controller.dart';
import 'package:opinion_easy/core/utils/widgets/custom_text_field.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  EditProfileView({super.key});



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
                                      : const AssetImage(
                                              'assets/images/user.jpg')
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
                CustomTextField(
                  title: "Name",
                  controller: controller.nameController,
                  hintText: "e.g. Raj Kumar",
                  keyboardType: TextInputType.name,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
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

                // ── Email (Fixed from Google account) ────
                CustomTextField(
                  title: "Email Address",
                  controller: controller.emailController,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "example@email.com",
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

                // ── Address ───────────────────────────────
                CustomTextField(
                  title: "Address",
                  maxLines: 2,
                  controller: controller.addressController,
                  hintText: "23/234, Soft Link Road, Sec-32, 112345",
                  keyboardType: TextInputType.streetAddress,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Address is required' : null,
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
