// lib/data/model/bank_details_model.dart

class BankDetailsModel {
  final String? id;
  final int? customerId;
  final String accountHolderName;
  final String ifsc;
  final String accountNo;
  final String? upiId;
  final String? bankName;
  final String? branchName;
  final String? state;
  final String? city;
  final String? createdAt;
  final String? updatedAt;

  BankDetailsModel({
    this.id,
    this.customerId,
    required this.accountHolderName,
    required this.ifsc,
    required this.accountNo,
    this.upiId,
    this.bankName,
    this.branchName,
    this.state,
    this.city,
    this.createdAt,
    this.updatedAt,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id']?.toString(),
      customerId: json['customer_id'] as int?,
      accountHolderName: json['account_holder_name'] ?? '',
      ifsc: json['ifsc'] ?? '',
      accountNo: json['account_no'] ?? '',
      upiId: json['upi_id']?.toString(),
      bankName: json['bank_name']?.toString(),
      branchName: json['branch_name']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      'account_holder_name': accountHolderName,
      'ifsc': ifsc,
      'account_no': accountNo,
      if (upiId != null) 'upi_id': upiId,
      if (bankName != null) 'bank_name': bankName,
      if (branchName != null) 'branch_name': branchName,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
