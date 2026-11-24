// lib/view/profile/profile_content/edit_bank_details_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/bank_controller.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/widgets/custom_text_field.dart';

class BankFormBottomSheet extends StatelessWidget {
  final BankDetailsController controller;
  final bool isEdit;

  const BankFormBottomSheet({
    super.key,
    required this.controller,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Obx(
            () => Form(
              key: controller.formKey,
              autovalidateMode: controller.autoValidateMode.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Drag Handle ─────────────────────────────
                  Center(
                    child: Container(
                      width: 42,
                      height: 4.5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // ── Header Row ──────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor1.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                AppColor.primaryColor1.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.account_balance_rounded,
                          color: AppColor.primaryColor1,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Edit Bank Account' : 'Add Bank Account',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEdit
                                  ? 'Update your bank account information'
                                  : 'Enter bank account details for withdrawals',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ── Field 1: Account Holder Name ─────────────
                  _buildBankInputField(
                    label: "Account Holder Name",
                    hint: "Account Holder Name",
                    controller: controller.accountHolderNameController,
                    focusNode: controller.accountHolderFocus,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    iconWidget: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColor.primaryColor1,
                      size: 18,
                    ),
                    validator: controller.validateAccountHolderName,
                  ),
                  const SizedBox(height: 16),

                  // ── Field 2: Account Number (9 to 18 digits) ─
                  _buildBankInputField(
                    label: "Account Number",
                    hint: "Account Number",
                    controller: controller.accountNoController,
                    focusNode: controller.accountNoFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(18),
                    ],
                    iconWidget: const Icon(
                      Icons.badge_outlined,
                      color: AppColor.primaryColor1,
                      size: 18,
                    ),
                    validator: controller.validateAccountNo,
                  ),
                  const SizedBox(height: 16),

                  // ── Field 3: Confirm Account Number ──────────
                  _buildBankInputField(
                    label: "Confirm Account Number",
                    hint: "Confirm Account Number",
                    controller: controller.confirmAccountNoController,
                    focusNode: controller.confirmAccountNoFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(18),
                    ],
                    iconWidget: const Icon(
                      Icons.badge_outlined,
                      color: AppColor.primaryColor1,
                      size: 18,
                    ),
                    validator: controller.validateConfirmAccountNo,
                  ),
                  const SizedBox(height: 16),

                  // ── Field 4: IFSC Code (11 alphanumeric, triggers Razorpay lookup)
                  _buildBankInputField(
                    label: "IFSC Code",
                    hint: "IFSC Code (e.g. SBIN0000691)",
                    controller: controller.ifscController,
                    focusNode: controller.ifscFocus,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    onChanged: controller.onIfscChanged,
                    iconWidget: const Text(
                      "#",
                      style: TextStyle(
                        color: AppColor.primaryColor1,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    suffixWidget: controller.isFetchingIfsc.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.primaryColor1,
                              ),
                            ),
                          )
                        : (controller.isIfscValid.value
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF00C853),
                                size: 20,
                              )
                            : (controller.ifscError.value != null &&
                                    controller.ifscError.value!.isNotEmpty
                                ? const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFFF4757),
                                    size: 20,
                                  )
                                : null)),
                    validator: controller.validateIFSC,
                  ),
                  if (controller.ifscError.value != null &&
                      controller.ifscError.value!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4757).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              const Color(0xFFFF4757).withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFFF4757),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.ifscError.value!,
                              style: const TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // ── Field 5: UPI ID (Optional) ─────────────
                  _buildBankInputField(
                    label: "UPI ID (Optional)",
                    hint: "e.g. username@okhdfcbank",
                    controller: controller.upiIdController,
                    focusNode: controller.upiIdFocus,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9.\-_@]'),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    iconWidget: const Icon(
                      Icons.alternate_email_rounded,
                      color: AppColor.primaryColor1,
                      size: 18,
                    ),
                    validator: controller.validateUpiId,
                  ),

                  // ── Auto-fetched fields (Bank Name, Branch Name, Bank State, Bank City)
                  if (controller.isIfscValid.value) ...[
                    const SizedBox(height: 16),

                    // Field 5: Bank Name
                    _buildBankInputField(
                      label: "Bank Name",
                      hint: "Bank Name",
                      controller: controller.bankNameController,
                      readOnly: true,
                      iconWidget: const Icon(
                        Icons.account_balance_outlined,
                        color: AppColor.primaryColor1,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 6: Branch Name
                    _buildBankInputField(
                      label: "Branch Name",
                      hint: "Branch Name",
                      controller: controller.branchNameController,
                      readOnly: true,
                      iconWidget: const Icon(
                        Icons.badge_outlined,
                        color: AppColor.primaryColor1,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 7: Bank State
                    _buildBankInputField(
                      label: "Bank State",
                      hint: "Bank State",
                      controller: controller.bankStateController,
                      readOnly: true,
                      iconWidget: const Icon(
                        Icons.location_on_outlined,
                        color: AppColor.primaryColor1,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field 8: Bank City
                    _buildBankInputField(
                      label: "Bank City",
                      hint: "Bank City",
                      controller: controller.bankCityController,
                      readOnly: true,
                      iconWidget: const Icon(
                        Icons.location_on_outlined,
                        color: AppColor.primaryColor1,
                        size: 18,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Bottom Action Button: ADD BANK / UPDATE BANK ──
                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final bool isSuccess = isEdit
                                ? await controller.updateBankDetail()
                                : await controller.addBankDetail();
                            if (isSuccess) Get.back();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor1,
                      disabledBackgroundColor:
                          AppColor.primaryColor1.withValues(alpha: 0.4),
                      foregroundColor: AppColor.card,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.card,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEdit ? 'UPDATE BANK' : 'ADD BANK',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColor.card,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Widget iconWidget,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    Widget? suffixWidget,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      title: label,
      hintText: hint,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChange: onChanged,
      validator: validator,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.primaryColor1.withValues(alpha: 0.5),
              width: 1.2,
            ),
            color: const Color(0xFF2A2E44),
          ),
          alignment: Alignment.center,
          child: iconWidget,
        ),
      ),
      suffixIcon: suffixWidget != null
          ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffixWidget,
            )
          : null,
      fillColor:
          readOnly ? const Color(0xFF1D2132) : const Color(0xFF1C1F2A),
      borderColor: readOnly
          ? const Color(0xFF2C3249)
          : Colors.white.withValues(alpha: 0.1),
      focusedBorderColor: AppColor.primaryColor1,
      borderRadius: BorderRadius.circular(16),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    );
  }
}
