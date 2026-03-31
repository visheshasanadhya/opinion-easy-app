class SubCategModel {
  final int? id;
  final int? categoryId;
  final String? name;
  final String? description;
  final bool? status;
  final int? leftQuestionCount;
  final String? createdAt;
  final String? updatedAt;

  SubCategModel({
    this.id,
    this.categoryId,
    this.name,
    this.description,
    this.status,
    this.leftQuestionCount,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategModel.fromJson(Map<String, dynamic> json) {
    return SubCategModel(
      id: json['id'] as int?,
      categoryId: json['category_id'] as int?,
      name: json['name'].toString(),
      description: json['description'].toString(),
      status: json['status'] == true || json['status'] == 1,
      leftQuestionCount: json['left_question_count'] ?? 0,
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );
  }
}
