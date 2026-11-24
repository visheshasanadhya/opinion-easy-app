// lib/data/model/bank_details_model.dart

class BankDetailsModel {
  final String? id;
  final String accountHolderName;
  final String ifsc;
  final String accountNo;
  final String? bankName;
  final String? branchName;
  final String? state;
  final String? city;
  final String? createdAt;

  BankDetailsModel({
    this.id,
    required this.accountHolderName,
    required this.ifsc,
    required this.accountNo,
    this.bankName,
    this.branchName,
    this.state,
    this.city,
    this.createdAt,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id']?.toString(),
      accountHolderName: json['account_holder_name'] ?? '',
      ifsc: json['ifsc'] ?? '',
      accountNo: json['account_no'] ?? '',
      bankName: json['bank_name']?.toString(),
      branchName: json['branch_name']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'account_holder_name': accountHolderName,
      'ifsc': ifsc,
      'account_no': accountNo,
      if (bankName != null) 'bank_name': bankName,
      if (branchName != null) 'branch_name': branchName,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
    };
  }
}
