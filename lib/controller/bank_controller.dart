// lib/controller/bank_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/widgets/invalid_ifsc_bottom_sheet.dart';
import '../data/model/bank_details_model.dart';
import '../data/model/razorpay_ifsc_model.dart';
import '../data/service/bank_details_service.dart';
import '../data/service/razorpay_ifsc_api.dart';

class BankDetailsController extends GetxController {
  final BankDetailsService _service = BankDetailsService();

  // Observables
  final bankDetails = <BankDetailsModel>[].obs;
  final isLoading = false.obs;
  final isFetchingIfsc = false.obs;
  final isIfscValid = false.obs;
  final selectedBankDetail = Rxn<BankDetailsModel>();
  final ifscData = Rxn<RazorpayIfscModel>();

  // Input Controllers
  final accountHolderNameController = TextEditingController();
  final accountNoController = TextEditingController();
  final confirmAccountNoController = TextEditingController();
  final ifscController = TextEditingController();

  // Auto-populated Controllers from Razorpay IFSC API
  final bankNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final bankStateController = TextEditingController();
  final bankCityController = TextEditingController();

  // Focus Nodes
  final accountHolderFocus = FocusNode();
  final accountNoFocus = FocusNode();
  final confirmAccountNoFocus = FocusNode();
  final ifscFocus = FocusNode();

  final formKey = GlobalKey<FormState>();
  final autoValidateMode = AutovalidateMode.disabled.obs;

  String _lastCheckedIfsc = "";

  // Validation Rules
  /// IFSC Code Rule: 11 characters. First 4 alphabets, 5th character '0', last 6 alphanumeric.
  static final RegExp ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  /// Account Number Rule: 9 to 18 numeric digits only.
  static final RegExp accountRegex = RegExp(r'^[0-9]{9,18}$');

  @override
  void onInit() {
    super.onInit();
    fetchBankDetails();
  }

  @override
  void onClose() {
    accountHolderNameController.dispose();
    accountNoController.dispose();
    confirmAccountNoController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    bankStateController.dispose();
    bankCityController.dispose();

    accountHolderFocus.dispose();
    accountNoFocus.dispose();
    confirmAccountNoFocus.dispose();
    ifscFocus.dispose();

    super.onClose();
  }

  /// Triggered whenever user edits IFSC Code
  void onIfscChanged(String value) {
    final code = value.trim().toUpperCase();

    if (code.length == 11) {
      verifyAndFetchIfsc(code, showDialogOnError: true);
    } else {
      if (isIfscValid.value) {
        isIfscValid.value = false;
        ifscData.value = null;
        bankNameController.clear();
        branchNameController.clear();
        bankStateController.clear();
        bankCityController.clear();
      }
    }
  }

  /// Checks IFSC format via regex & calls free Razorpay IFSC API
  Future<bool> verifyAndFetchIfsc(
    String code, {
    bool showDialogOnError = true,
  }) async {
    final ifsc = code.trim().toUpperCase();

    // 1. Length check
    if (ifsc.length != 11) {
      _resetIfscFields();
      if (showDialogOnError) {
        InvalidIfscBottomSheet.show(
          message: "IFSC Code must be 11 characters.",
        );
      }
      return false;
    }

    // 2. Format validation (Regex: 4 letters, '0', 6 alphanumeric)
    if (!ifscRegex.hasMatch(ifsc)) {
      _resetIfscFields();
      if (showDialogOnError) {
        InvalidIfscBottomSheet.show(
          message:
              "Invalid IFSC format.\n5th character must be '0' and first 4 characters must be alphabets.",
        );
      }
      return false;
    }

    // If already verified for the same code, do not re-fetch
    if (ifsc == _lastCheckedIfsc && isIfscValid.value) {
      return true;
    }

    // 3. Call Razorpay IFSC API
    try {
      isFetchingIfsc.value = true;
      final result = await RazorpayIfscApi.callApi(ifsc);

      if (result != null && (result.bank ?? "").isNotEmpty) {
        ifscData.value = result;
        isIfscValid.value = true;
        _lastCheckedIfsc = ifsc;
        bankNameController.text = result.bank ?? "";
        branchNameController.text = result.branch ?? "";
        bankStateController.text = result.state ?? "";
        bankCityController.text = result.city ?? "";
        return true;
      } else {
        _resetIfscFields();
        if (showDialogOnError) {
          InvalidIfscBottomSheet.show(
            message: "Invalid IFSC Code.\nBank details not found for this IFSC.",
          );
        }
        return false;
      }
    } catch (e) {
      _resetIfscFields();
      if (showDialogOnError) {
        InvalidIfscBottomSheet.show(
          message: "Unable to verify IFSC. Please check your connection.",
        );
      }
      return false;
    } finally {
      isFetchingIfsc.value = false;
    }
  }

  void _resetIfscFields() {
    isIfscValid.value = false;
    ifscData.value = null;
    _lastCheckedIfsc = "";
    bankNameController.clear();
    branchNameController.clear();
    bankStateController.clear();
    bankCityController.clear();
  }

  /// Fetch all bank details
  Future<void> fetchBankDetails() async {
    try {
      isLoading.value = true;
      final response = await _service.getBankDetails();

      if (response["status"] == true) {
        final List<dynamic> data = response["data"] ?? [];
        bankDetails.value =
            data.map((json) => BankDetailsModel.fromJson(json)).toList();
      } else {
        _showErrorSnackbar(response["message"] ?? "Failed to fetch data");
      }
    } catch (e) {
      _showErrorSnackbar("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new bank detail
  Future<bool> addBankDetail() async {
    if (!_validateForm()) return false;

    if (!isIfscValid.value) {
      final ifscOk = await verifyAndFetchIfsc(
        ifscController.text.trim().toUpperCase(),
        showDialogOnError: true,
      );
      if (!ifscOk) return false;
    }

    try {
      isLoading.value = true;
      final data = _getFormData();
      final response = await _service.addBankDetail(data);

      if (response["status"] == true) {
        clearForm();
        fetchBankDetails();
        _showSuccessSnackbar("Bank details added successfully");
        return true;
      } else {
        _showErrorSnackbar(response["message"] ?? "Failed to add bank detail");
        return false;
      }
    } catch (e) {
      _showErrorSnackbar("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update bank detail
  Future<bool> updateBankDetail() async {
    if (!_validateForm()) return false;
    if (selectedBankDetail.value?.id == null) {
      _showErrorSnackbar("No bank detail selected for update");
      return false;
    }

    if (!isIfscValid.value) {
      final ifscOk = await verifyAndFetchIfsc(
        ifscController.text.trim().toUpperCase(),
        showDialogOnError: true,
      );
      if (!ifscOk) return false;
    }

    try {
      isLoading.value = true;
      final data = _getFormData();
      final response = await _service.updateBankDetail(
        selectedBankDetail.value!.id!,
        data,
      );

      if (response["status"] == true) {
        clearForm();
        fetchBankDetails();
        _showSuccessSnackbar("Bank details updated successfully");
        return true;
      } else {
        _showErrorSnackbar(
          response["message"] ?? "Failed to update bank detail",
        );
        return false;
      }
    } catch (e) {
      _showErrorSnackbar("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete bank detail
  Future<void> deleteBankDetail(String id) async {
    try {
      isLoading.value = true;
      final response = await _service.deleteBankDetail(id);

      if (response["status"] == true) {
        fetchBankDetails();
      } else {
        _showErrorSnackbar(
          response["message"] ?? "Failed to delete bank detail",
        );
      }
    } catch (e) {
      _showErrorSnackbar("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Load bank detail for editing
  void loadBankDetailForEdit(BankDetailsModel bankDetail) {
    selectedBankDetail.value = bankDetail;
    accountHolderNameController.text = bankDetail.accountHolderName;
    accountNoController.text = bankDetail.accountNo;
    confirmAccountNoController.text = bankDetail.accountNo;
    ifscController.text = bankDetail.ifsc;
    bankNameController.text = bankDetail.bankName ?? "";
    branchNameController.text = bankDetail.branchName ?? "";
    bankStateController.text = bankDetail.state ?? "";
    bankCityController.text = bankDetail.city ?? "";
    autoValidateMode.value = AutovalidateMode.disabled;

    if (bankDetail.ifsc.isNotEmpty) {
      verifyAndFetchIfsc(bankDetail.ifsc, showDialogOnError: false);
    }
  }

  /// Clear form
  void clearForm() {
    accountHolderNameController.clear();
    accountNoController.clear();
    confirmAccountNoController.clear();
    ifscController.clear();
    bankNameController.clear();
    branchNameController.clear();
    bankStateController.clear();
    bankCityController.clear();
    selectedBankDetail.value = null;
    isIfscValid.value = false;
    ifscData.value = null;
    _lastCheckedIfsc = "";
    autoValidateMode.value = AutovalidateMode.disabled;
    formKey.currentState?.reset();
  }

  /// Get form data
  Map<String, dynamic> _getFormData() {
    return {
      'account_holder_name': accountHolderNameController.text.trim(),
      'ifsc': ifscController.text.trim().toUpperCase(),
      'account_no': accountNoController.text.trim(),
      if (bankNameController.text.trim().isNotEmpty)
        'bank_name': bankNameController.text.trim(),
      if (branchNameController.text.trim().isNotEmpty)
        'branch_name': branchNameController.text.trim(),
      if (bankStateController.text.trim().isNotEmpty)
        'state': bankStateController.text.trim(),
      if (bankCityController.text.trim().isNotEmpty)
        'city': bankCityController.text.trim(),
    };
  }

  /// Validate form
  bool _validateForm() {
    autoValidateMode.value = AutovalidateMode.onUserInteraction;
    return formKey.currentState?.validate() ?? false;
  }

  /// Account Holder Name Validator
  String? validateAccountHolderName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account holder name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Name must not exceed 100 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s\-'.]+$").hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  /// Account Number Validator (9 to 18 numeric digits)
  String? validateAccountNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    final accountNo = value.trim();
    if (!accountRegex.hasMatch(accountNo)) {
      return 'Account number must be 9 to 18 digits';
    }
    return null;
  }

  /// Confirm Account Number Validator (Must match Account Number)
  String? validateConfirmAccountNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm account number is required';
    }
    final confirmNo = value.trim();
    if (!accountRegex.hasMatch(confirmNo)) {
      return 'Confirm account number must be 9 to 18 digits';
    }
    if (confirmNo != accountNoController.text.trim()) {
      return 'Account numbers do not match';
    }
    return null;
  }

  /// IFSC Code Validator
  String? validateIFSC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    final code = value.trim().toUpperCase();
    if (code.length != 11) {
      return 'IFSC code must be 11 characters';
    }
    if (!ifscRegex.hasMatch(code)) {
      return 'Invalid IFSC format (e.g. SBIN0000691)';
    }
    if (!isIfscValid.value) {
      return 'Please enter a valid verified IFSC code';
    }
    return null;
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }
}
