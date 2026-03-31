// lib/controller/bank_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/bank_details_model.dart';
import '../data/service/bank_details_service.dart';

class BankDetailsController extends GetxController {
  final BankDetailsService _service = BankDetailsService();

  // Observables
  final bankDetails = <BankDetailsModel>[].obs;
  final isLoading = false.obs;
  final selectedBankDetail = Rxn<BankDetailsModel>();

  // Form controllers
  final accountHolderNameController = TextEditingController();
  final ifscController = TextEditingController();
  final accountNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Auto-validate mode
  final autoValidateMode = AutovalidateMode.disabled.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBankDetails();
  }

  @override
  void onClose() {
    accountHolderNameController.dispose();
    ifscController.dispose();
    accountNoController.dispose();
    super.onClose();
  }

  /// Fetch all bank details
  Future<void> fetchBankDetails() async {
    try {
      isLoading.value = true;
      final response = await _service.getBankDetails();

      if (response["status"] == true) {
        final List<dynamic> data = response["data"] ?? [];
        bankDetails.value = data
            .map((json) => BankDetailsModel.fromJson(json))
            .toList();
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

    try {
      isLoading.value = true;
      final data = _getFormData();
      final response = await _service.addBankDetail(data);

      if (response["status"] == true) {
        clearForm();
        fetchBankDetails();
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
    ifscController.text = bankDetail.ifsc!;
    accountNoController.text = bankDetail.accountNo!;
    autoValidateMode.value = AutovalidateMode.disabled;
  }

  /// Clear form
  void clearForm() {
    accountHolderNameController.clear();
    ifscController.clear();
    accountNoController.clear();
    selectedBankDetail.value = null;
    autoValidateMode.value = AutovalidateMode.disabled;
    formKey.currentState?.reset();
  }

  /// Get form data
  Map<String, dynamic> _getFormData() {
    return {
      'account_holder_name': accountHolderNameController.text.trim(),
      'ifsc': ifscController.text.trim().toUpperCase(),
      'account_no': accountNoController.text.trim(),
    };
  }

  /// Validate form
  bool _validateForm() {
    autoValidateMode.value = AutovalidateMode.onUserInteraction;
    return formKey.currentState?.validate() ?? false;
  }

  /// International Account Holder Name Validator
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
    // Allow letters, spaces, hyphens, apostrophes, and periods (international names)
    if (!RegExp(r"^[a-zA-Z\s\-'.]+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  /// International Bank Code Validator (IFSC/SWIFT/BIC/Routing Number)
  String? validateIFSC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank code is required';
    }

    final code = value.trim().toUpperCase();

    // Length validation: 4-34 characters (covers most international formats)
    if (code.length < 4 || code.length > 34) {
      return 'Bank code must be 4-34 characters';
    }

    // Allow alphanumeric characters (covers IFSC, SWIFT, BIC, Routing numbers)
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
      return 'Bank code can only contain letters and numbers';
    }

    // Optional: Specific format validation based on length
    // IFSC (India): 11 characters - ABCD0123456
    if (code.length == 11) {
      if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(code)) {
        return 'Invalid IFSC code format (India)';
      }
    }
    // SWIFT/BIC: 8 or 11 characters - AAAABBCCXXX
    else if (code.length == 8 || code.length == 11) {
      if (!RegExp(r'^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$').hasMatch(code)) {
        return 'Invalid SWIFT/BIC code format';
      }
    }
    // US Routing Number: 9 digits
    else if (code.length == 9) {
      if (!RegExp(r'^\d{9}$').hasMatch(code)) {
        return 'Invalid routing number format (US)';
      }
    }

    return null;
  }

  /// International Account Number Validator (supports various formats)
  String? validateAccountNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }

    final accountNo = value.trim();

    // Length validation: 4-34 characters (IBAN can be up to 34 chars)
    if (accountNo.length < 4 || accountNo.length > 34) {
      return 'Account number must be 4-34 characters';
    }

    // Allow alphanumeric (supports IBAN and regular account numbers)
    if (!RegExp(r'^[A-Z0-9]+$', caseSensitive: false).hasMatch(accountNo)) {
      return 'Account number can only contain letters and numbers';
    }

    // IBAN validation (if starts with 2 letters)
    if (RegExp(r'^[A-Z]{2}', caseSensitive: false).hasMatch(accountNo)) {
      return _validateIBAN(accountNo);
    }

    // Regular account number (most countries): 6-18 digits
    if (RegExp(r'^\d+$').hasMatch(accountNo)) {
      if (accountNo.length < 6 || accountNo.length > 18) {
        return 'Account number should be 6-18 digits';
      }
    }

    return null;
  }

  /// IBAN Validation (Basic check)
  String? _validateIBAN(String iban) {
    final ibanUpperCase = iban.toUpperCase().replaceAll(' ', '');

    // IBAN length by country (sample - you can expand this)
    final Map<String, int> ibanLengths = {
      'AD': 24,
      'AE': 23,
      'AL': 28,
      'AT': 20,
      'AZ': 28,
      'BA': 20,
      'BE': 16,
      'BG': 22,
      'BH': 22,
      'BR': 29,
      'CH': 21,
      'CR': 22,
      'CY': 28,
      'CZ': 24,
      'DE': 22,
      'DK': 18,
      'DO': 28,
      'EE': 20,
      'ES': 24,
      'FI': 18,
      'FO': 18,
      'FR': 27,
      'GB': 22,
      'GE': 22,
      'GI': 23,
      'GL': 18,
      'GR': 27,
      'GT': 28,
      'HR': 21,
      'HU': 28,
      'IE': 22,
      'IL': 23,
      'IS': 26,
      'IT': 27,
      'JO': 30,
      'KW': 30,
      'KZ': 20,
      'LB': 28,
      'LI': 21,
      'LT': 20,
      'LU': 20,
      'LV': 21,
      'MC': 27,
      'MD': 24,
      'ME': 22,
      'MK': 19,
      'MR': 27,
      'MT': 31,
      'MU': 30,
      'NL': 18,
      'NO': 15,
      'PK': 24,
      'PL': 28,
      'PS': 29,
      'PT': 25,
      'QA': 29,
      'RO': 24,
      'RS': 22,
      'SA': 24,
      'SE': 24,
      'SI': 19,
      'SK': 24,
      'SM': 27,
      'TN': 24,
      'TR': 26,
      'UA': 29,
      'VA': 22,
      'VG': 24,
      'XK': 20,
    };

    if (ibanUpperCase.length < 15 || ibanUpperCase.length > 34) {
      return 'Invalid IBAN length';
    }

    final countryCode = ibanUpperCase.substring(0, 2);

    if (ibanLengths.containsKey(countryCode)) {
      if (ibanUpperCase.length != ibanLengths[countryCode]) {
        return 'Invalid IBAN length for $countryCode';
      }
    }

    return null; // Basic validation passed
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

// // lib/controller/bank_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../data/model/bank_details_model.dart';
// import '../data/service/bank_details_service.dart';
//
// class BankDetailsController extends GetxController {
//   final BankDetailsService _service = BankDetailsService();
//
//   // Observables
//   final bankDetails = <BankDetailsModel>[].obs;
//   final isLoading = false.obs;
//   final selectedBankDetail = Rxn<BankDetailsModel>();
//   final isUpiSelected = false.obs; // NEW: Toggle between Bank and UPI forms
//
//   // Form controllers
//   final accountHolderNameController = TextEditingController();
//   final upiIdController = TextEditingController(); // NEW: UPI ID Controller
//   final ifscController = TextEditingController();
//   final accountNoController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   // Auto-validate mode
//   final autoValidateMode = AutovalidateMode.disabled.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchBankDetails();
//   }
//
//   @override
//   void onClose() {
//     accountHolderNameController.dispose();
//     upiIdController.dispose(); // Dispose new controller
//     ifscController.dispose();
//     accountNoController.dispose();
//     super.onClose();
//   }
//
//   /// Fetch all bank details
//   Future<void> fetchBankDetails() async {
//     try {
//       isLoading.value = true;
//       // Assuming _service.getBankDetails() returns a map with "status" and "data"
//       final response = await _service.getBankDetails();
//
//       if (response["status"] == true) {
//         final List<dynamic> data = response["data"] ?? [];
//         bankDetails.value = data
//             .map((json) => BankDetailsModel.fromJson(json))
//             .toList();
//       } else {
//         _showErrorSnackbar(response["message"] ?? "Failed to fetch data");
//       }
//     } catch (e) {
//       _showErrorSnackbar("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Add new bank detail
//   Future<bool> addBankDetail() async {
//     if (!_validateForm()) return false;
//
//     try {
//       isLoading.value = true;
//       final data = _getFormData();
//       // Assuming _service.addBankDetail(data) returns a map with "status" and "message"
//       final response = await _service.addBankDetail(data);
//
//       if (response["status"] == true) {
//         _showSuccessSnackbar("Payment method added successfully!");
//         clearForm();
//         fetchBankDetails();
//         return true;
//       } else {
//         _showErrorSnackbar(response["message"] ?? "Failed to add bank detail");
//         return false;
//       }
//     } catch (e) {
//       _showErrorSnackbar("Error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Update bank detail
//   Future<bool> updateBankDetail() async {
//     if (!_validateForm()) return false;
//     if (selectedBankDetail.value?.id == null) {
//       _showErrorSnackbar("No payment method selected for update");
//       return false;
//     }
//
//     try {
//       isLoading.value = true;
//       final data = _getFormData();
//       // Assuming _service.updateBankDetail returns a map with "status" and "message"
//       final response = await _service.updateBankDetail(
//         selectedBankDetail.value!.id!,
//         data,
//       );
//
//       if (response["status"] == true) {
//         _showSuccessSnackbar("Payment method updated successfully!");
//         clearForm();
//         fetchBankDetails();
//         return true;
//       } else {
//         _showErrorSnackbar(
//           response["message"] ?? "Failed to update bank detail",
//         );
//         return false;
//       }
//     } catch (e) {
//       _showErrorSnackbar("Error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Delete bank detail
//   Future<void> deleteBankDetail(String id) async {
//     try {
//       isLoading.value = true;
//       // Assuming _service.deleteBankDetail(id) returns a map with "status" and "message"
//       final response = await _service.deleteBankDetail(id);
//
//       if (response["status"] == true) {
//         _showSuccessSnackbar("Payment method deleted successfully!");
//         fetchBankDetails();
//       } else {
//         _showErrorSnackbar(
//           response["message"] ?? "Failed to delete bank detail",
//         );
//       }
//     } catch (e) {
//       _showErrorSnackbar("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Load bank detail for editing
//   void loadBankDetailForEdit(BankDetailsModel bankDetail) {
//     selectedBankDetail.value = bankDetail;
//     accountHolderNameController.text = bankDetail.accountHolderName;
//
//     // Determine if it's a UPI entry
//     isUpiSelected.value =
//         bankDetail.upiId != null && bankDetail.upiId!.isNotEmpty;
//
//     if (isUpiSelected.value) {
//       upiIdController.text = bankDetail.upiId!;
//       // Clear bank fields
//       ifscController.clear();
//       accountNoController.clear();
//     } else {
//       // Clear UPI field
//       upiIdController.clear();
//       // Load bank fields
//       ifscController.text = bankDetail.ifsc ?? '';
//       accountNoController.text = bankDetail.accountNo ?? '';
//     }
//     autoValidateMode.value = AutovalidateMode.disabled;
//   }
//
//   /// Clear form
//   void clearForm() {
//     accountHolderNameController.clear();
//     upiIdController.clear();
//     ifscController.clear();
//     accountNoController.clear();
//     selectedBankDetail.value = null;
//     isUpiSelected.value = false; // Reset toggle
//     autoValidateMode.value = AutovalidateMode.disabled;
//     formKey.currentState?.reset();
//   }
//
//   /// Get form data
//   Map<String, dynamic> _getFormData() {
//     final Map<String, dynamic> data = {
//       'account_holder_name': accountHolderNameController.text.trim(),
//     };
//
//     if (isUpiSelected.value) {
//       // Send UPI data and nullify bank data
//       data['upi_id'] = upiIdController.text.trim();
//     } else {
//       // Send Bank data and nullify UPI data
//       data['ifsc'] = ifscController.text.trim().toUpperCase();
//       data['account_no'] = accountNoController.text.trim();
//     }
//     return data;
//   }
//
//   /// Validate form
//   bool _validateForm() {
//     // Manually trigger validation for the required fields
//     autoValidateMode.value = AutovalidateMode.onUserInteraction;
//
//     bool isAccountHolderNameValid =
//         validateAccountHolderName(accountHolderNameController.text) == null;
//
//     bool isSpecificValid = false;
//
//     if (isUpiSelected.value) {
//       // Validate only UPI ID
//       isSpecificValid = validateUpiId(upiIdController.text) == null;
//     } else {
//       // Validate only Bank Details
//       bool isIfscValid = validateIFSC(ifscController.text) == null;
//       bool isAccountNoValid =
//           validateAccountNo(accountNoController.text) == null;
//       isSpecificValid = isIfscValid && isAccountNoValid;
//     }
//
//     // Check if the form state itself is valid (ensures text fields reflect errors)
//     bool isFormStateValid = formKey.currentState?.validate() ?? false;
//
//     // We return true if both the common field (name) and the specific fields (UPI or Bank) are valid.
//     return isAccountHolderNameValid && isSpecificValid && isFormStateValid;
//   }
//
//   // --- Validators ---
//
//   // NEW: UPI ID Validator
//   String? validateUpiId(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'UPI ID is required';
//     }
//     final upi = value.trim();
//     // Basic UPI format check: a-z, 0-9, periods, hyphens, @
//     if (!RegExp(r'^[a-zA-Z0-9.\-_]+@[a-zA-Z0-9.\-_]+$').hasMatch(upi)) {
//       return 'Invalid UPI ID format (e.g., username@bankname)';
//     }
//     return null;
//   }
//
//   /// International Account Holder Name Validator
//   String? validateAccountHolderName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Account holder name is required';
//     }
//     if (value.trim().length < 2) {
//       return 'Name must be at least 2 characters';
//     }
//     if (value.trim().length > 100) {
//       return 'Name must not exceed 100 characters';
//     }
//     if (!RegExp(r"^[a-zA-Z\s\-'.]+$").hasMatch(value)) {
//       return 'Name can only contain letters, spaces, hyphens, and apostrophes';
//     }
//     return null;
//   }
//
//   /// International Bank Code Validator (IFSC/SWIFT/BIC/Routing Number)
//   String? validateIFSC(String? value) {
//     // Only validate if Bank Details are selected
//     if (isUpiSelected.isFalse) {
//       if (value == null || value.trim().isEmpty) {
//         return 'Bank code is required';
//       }
//
//       final code = value.trim().toUpperCase();
//
//       if (code.length < 4 || code.length > 34) {
//         return 'Bank code must be 4-34 characters';
//       }
//
//       if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
//         return 'Bank code can only contain letters and numbers';
//       }
//
//       // IFSC (India): 11 characters - ABCD0123456
//       if (code.length == 11) {
//         if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(code)) {
//           return 'Invalid IFSC code format (India)';
//         }
//       }
//       // SWIFT/BIC: 8 or 11 characters
//       else if (code.length == 8 || code.length == 11) {
//         if (!RegExp(r'^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$').hasMatch(code)) {
//           return 'Invalid SWIFT/BIC code format';
//         }
//       }
//       // US Routing Number: 9 digits
//       else if (code.length == 9) {
//         if (!RegExp(r'^\d{9}$').hasMatch(code)) {
//           return 'Invalid routing number format (US)';
//         }
//       }
//     }
//     return null;
//   }
//
//   /// International Account Number Validator (supports various formats)
//   String? validateAccountNo(String? value) {
//     // Only validate if Bank Details are selected
//     if (isUpiSelected.isFalse) {
//       if (value == null || value.trim().isEmpty) {
//         return 'Account number is required';
//       }
//
//       final accountNo = value.trim();
//
//       if (accountNo.length < 4 || accountNo.length > 34) {
//         return 'Account number must be 4-34 characters';
//       }
//
//       if (!RegExp(r'^[A-Z0-9]+$', caseSensitive: false).hasMatch(accountNo)) {
//         return 'Account number can only contain letters and numbers';
//       }
//
//       // IBAN validation (if starts with 2 letters)
//       if (RegExp(r'^[A-Z]{2}', caseSensitive: false).hasMatch(accountNo)) {
//         return _validateIBAN(accountNo);
//       }
//
//       // Regular account number (most countries): 6-18 digits
//       if (RegExp(r'^\d+$').hasMatch(accountNo)) {
//         if (accountNo.length < 6 || accountNo.length > 18) {
//           return 'Account number should be 6-18 digits';
//         }
//       }
//     }
//     return null;
//   }
//
//   /// IBAN Validation (Basic check)
//   String? _validateIBAN(String iban) {
//     // (IBAN validation logic remains the same)
//     final ibanUpperCase = iban.toUpperCase().replaceAll(' ', '');
//
//     final Map<String, int> ibanLengths = {
//       'AD': 24,
//       'AE': 23,
//       'AL': 28,
//       'AT': 20,
//       'AZ': 28,
//       'BA': 20,
//       'BE': 16,
//       'BG': 22,
//       'BH': 22,
//       'BR': 29,
//       'CH': 21,
//       'CR': 22,
//       'CY': 28,
//       'CZ': 24,
//       'DE': 22,
//       'DK': 18,
//       'DO': 28,
//       'EE': 20,
//       'ES': 24,
//       'FI': 18,
//       'FO': 18,
//       'FR': 27,
//       'GB': 22,
//       'GE': 22,
//       'GI': 23,
//       'GL': 18,
//       'GR': 27,
//       'GT': 28,
//       'HR': 21,
//       'HU': 28,
//       'IE': 22,
//       'IL': 23,
//       'IS': 26,
//       'IT': 27,
//       'JO': 30,
//       'KW': 30,
//       'KZ': 20,
//       'LB': 28,
//       'LI': 21,
//       'LT': 20,
//       'LU': 20,
//       'LV': 21,
//       'MC': 27,
//       'MD': 24,
//       'ME': 22,
//       'MK': 19,
//       'MR': 27,
//       'MT': 31,
//       'MU': 30,
//       'NL': 18,
//       'NO': 15,
//       'PK': 24,
//       'PL': 28,
//       'PS': 29,
//       'PT': 25,
//       'QA': 29,
//       'RO': 24,
//       'RS': 22,
//       'SA': 24,
//       'SE': 24,
//       'SI': 19,
//       'SK': 24,
//       'SM': 27,
//       'TN': 24,
//       'TR': 26,
//       'UA': 29,
//       'VA': 22,
//       'VG': 24,
//       'XK': 20,
//     };
//
//     if (ibanUpperCase.length < 15 || ibanUpperCase.length > 34) {
//       return 'Invalid IBAN length';
//     }
//
//     final countryCode = ibanUpperCase.substring(0, 2);
//
//     if (ibanLengths.containsKey(countryCode)) {
//       if (ibanUpperCase.length != ibanLengths[countryCode]) {
//         return 'Invalid IBAN length for $countryCode';
//       }
//     }
//
//     return null;
//   }
//
//   /// Show success snackbar
//   void _showSuccessSnackbar(String message) {
//     Get.snackbar(
//       'Success',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green.shade600,
//       colorText: Colors.white,
//       icon: const Icon(Icons.check_circle, color: Colors.white),
//       margin: const EdgeInsets.all(16),
//       borderRadius: 8,
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   /// Show error snackbar
//   void _showErrorSnackbar(String message) {
//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red.shade600,
//       colorText: Colors.white,
//       icon: const Icon(Icons.error, color: Colors.white),
//       margin: const EdgeInsets.all(16),
//       borderRadius: 8,
//       duration: const Duration(seconds: 3),
//     );
//   }
// }
