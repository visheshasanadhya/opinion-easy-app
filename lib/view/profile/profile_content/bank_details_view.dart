// lib/view/bank/bank_details_view.dart
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/data/model/bank_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/widgets/custom_app_bar.dart';
import '../../../core/utils/widgets/app_loader.dart';
import '../../../controller/bank_controller.dart';
import 'edit_bank_details_view.dart';

class BankDetailsView extends StatelessWidget {
  const BankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BankDetailsController());

    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: const CustomAppBar(
        title: "Bank Details",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.bankDetails.isEmpty) {
          return const AppLoader();
        }

        return RefreshIndicator(
          color: AppColor.primaryColor1,
          backgroundColor: const Color(0xFF1A1A1A),
          onRefresh: () => controller.fetchBankDetails(),
          child: controller.bankDetails.isEmpty
              ? _buildEmptyState(controller)
              : _buildBankList(controller),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.clearForm();
                _showBankFormBottomSheet(context, controller, isEdit: false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                "Add Bank Account",
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BankDetailsController controller) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColor.primaryColor1.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primaryColor1.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.account_balance_rounded,
                size: 64,
                color: AppColor.primaryColor1,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Bank Details Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first bank account to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankList(BankDetailsController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.bankDetails.length,
      itemBuilder: (context, index) {
        final bankDetail = controller.bankDetails[index];
        return _buildBankCard(context, bankDetail, controller);
      },
    );
  }

  Widget _buildBankCard(
    BuildContext context,
    BankDetailsModel bankDetail,
    BankDetailsController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.04),
          onTap: () {
            controller.loadBankDetailForEdit(bankDetail);
            _showBankFormBottomSheet(context, controller, isEdit: true);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor1.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColor.primaryColor1.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColor.primaryColor1,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Bank Account',
                            style: TextStyle(
                              color: AppColor.primaryColor1,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                      color: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: 18,
                                color: AppColor.primaryColor1,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_rounded,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          controller.loadBankDetailForEdit(bankDetail);
                          _showBankFormBottomSheet(
                            context,
                            controller,
                            isEdit: true,
                          );
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, bankDetail, controller);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Account holder name ────────────────────
                Text(
                  bankDetail.accountHolderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                if (bankDetail.bankName != null &&
                    bankDetail.bankName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    bankDetail.branchName != null &&
                            bankDetail.branchName!.isNotEmpty
                        ? '${bankDetail.bankName} (${bankDetail.branchName})'
                        : bankDetail.bankName!,
                    style: const TextStyle(
                      color: AppColor.primaryColor1,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.06), height: 1),
                const SizedBox(height: 16),

                // ── Account number ─────────────────────────
                _detailRow(
                  label: 'ACCOUNT NUMBER',
                  value: bankDetail.accountNo,
                ),

                const SizedBox(height: 14),

                // ── IFSC ───────────────────────────────────
                _detailRow(label: 'IFSC / SWIFT CODE', value: bankDetail.ifsc),

                if (bankDetail.upiId != null &&
                    bankDetail.upiId!.trim().isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _detailRow(
                    label: 'UPI ID',
                    value: bankDetail.upiId!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  void _showBankFormBottomSheet(
    BuildContext context,
    BankDetailsController controller, {
    required bool isEdit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BankFormBottomSheet(controller: controller, isEdit: isEdit),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    BankDetailsModel bankDetail,
    BankDetailsController controller,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Bank Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete ${bankDetail.accountHolderName}\'s bank account? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.deleteBankDetail(bankDetail.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
