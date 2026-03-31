class HistoryModel {
  int? customerId;
  String? category;
  String? question;
  String? answer;
  bool? isPending;
  int? points;
  int? attemptPoint; // Mapped to 'attempt_point'
  String? createdAt;
  String? status; // Mapped to 'status'

  HistoryModel({
    this.customerId,
    this.category,
    this.question,
    this.answer,
    this.isPending,
    this.attemptPoint,
    this.points,
    this.createdAt,
    this.status,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      attemptPoint: json['attempt_point'] as int?, // Ensure correct type
      customerId: json['customer_id'] as int?,
      category: json['category'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      isPending: json['is_pending'] as bool?,
      points: json['points'] as int?, // Ensure correct type
      createdAt: json['created_at'] as String?,
      status: json['status'] as String?, // Ensure correct type
    );
  }
}

class RedeemModel {
  String? rewardName;
  int? points;
  String? status;
  String? remarks;
  String? approvedAt;
  String? createdAt;

  RedeemModel({
    this.rewardName,
    this.points,
    this.status,
    this.remarks,
    this.approvedAt,
    this.createdAt,
  });

  RedeemModel.fromJson(Map<String, dynamic> json) {
    rewardName = json['reward_name'];
    points = json['points'];
    status = json['status'];
    remarks = json['remarks'];
    approvedAt = json['approved_at'];
    createdAt = json['created_at'];
  }
}
