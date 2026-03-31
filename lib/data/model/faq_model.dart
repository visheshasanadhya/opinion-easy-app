class FAQsModel {
  final int? id;
  final String? question;
  final String? answer;
  final String? createdAt;
  final String? updatedAt;

  FAQsModel({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating model from JSON
  factory FAQsModel.fromJson(Map<String, dynamic> json) {
    return FAQsModel(
      id: json['id'] as int?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
