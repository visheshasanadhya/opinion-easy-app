// lib/data/model/bank_details_model.dart
class BankDetailsModel {
  final String? id;
  final String accountHolderName;
  final String ifsc;
  final String accountNo;
  final String? createdAt;

  BankDetailsModel({
    this.id,
    required this.accountHolderName,
    required this.ifsc,
    required this.accountNo,
    this.createdAt,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id']?.toString(),
      accountHolderName: json['account_holder_name'] ?? '',
      ifsc: json['ifsc'] ?? '',
      accountNo: json['account_no'] ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }
}

// // lib/data/model/bank_details_model.dart
//
// class BankDetailsModel {
//   final String? id;
//   final String accountHolderName;
//   final String? ifsc; // Made nullable
//   final String? accountNo; // Made nullable
//   final String? upiId; // NEW: Field to store UPI ID
//   final String? createdAt;
//
//   BankDetailsModel({
//     this.id,
//     required this.accountHolderName,
//     this.ifsc,
//     this.accountNo,
//     this.upiId, // NEW: Added to constructor
//     this.createdAt,
//   });
//
//   factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
//     return BankDetailsModel(
//       id: json['id']?.toString(),
//       accountHolderName: json['account_holder_name'] ?? '',
//       ifsc: json['ifsc'] as String?,
//       accountNo: json['account_no'] as String?,
//       upiId: json['upi_id'] as String?, // NEW: Map the 'upi_id' field
//       createdAt: json['created_at']?.toString(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'account_holder_name': accountHolderName,
//       'ifsc': ifsc,
//       'account_no': accountNo,
//       'upi_id': upiId,
//     };
//   }
// }
