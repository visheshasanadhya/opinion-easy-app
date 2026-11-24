class RazorpayIfscModel {
  final String? bank;
  final String? branch;
  final String? state;
  final String? city;

  RazorpayIfscModel({
    this.bank,
    this.branch,
    this.state,
    this.city,
  });

  factory RazorpayIfscModel.fromJson(Map<String, dynamic> json) {
    return RazorpayIfscModel(
      bank: json['BANK']?.toString(),
      branch: json['BRANCH']?.toString(),
      state: json['STATE']?.toString(),
      city: json['CITY']?.toString() ?? json['DISTRICT']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'BANK': bank,
        'BRANCH': branch,
        'STATE': state,
        'CITY': city,
      };
}
