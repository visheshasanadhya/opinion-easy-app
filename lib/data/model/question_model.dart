class QuestionModel {
  final String status;
  final List<Question> questions;

  QuestionModel({required this.status, required this.questions});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      status: json['status'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final int? categoryId;
  final int? subcategoryId;
  final String question;
  final int points;
  final int attempPoint;
  final String bannerLink;
  final String bannerImage;
  final String answerStatus;
  final bool? notificationSent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiryDate;
  final DateTime? visibleTime;
  final int yesCount;
  final int noCount;

  Question({
    required this.id,
    this.categoryId,
    this.subcategoryId,
    required this.question,
    required this.points,
    required this.attempPoint,
    required this.bannerLink,
    required this.bannerImage,
    required this.answerStatus,
    this.notificationSent,
    required this.createdAt,
    this.updatedAt,
    required this.expiryDate,
    required this.visibleTime,
    this.yesCount = 0,
    this.noCount = 0,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    return Question(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] as int?,
      subcategoryId: json['subcategory_id'] as int?,
      question: json['question'].toString(),
      points: json['points'] ?? 0,
      attempPoint: json['attempt_point'] ?? 0,
      bannerLink: json['banner_link'].toString(),
      bannerImage: json['banner_image'].toString(),
      answerStatus: json['answer_status'].toString(),
      notificationSent: json['notification_sent'] == true ||
          json['notification_sent'] == 1 ||
          json['notification_sent'] == '1',
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      expiryDate: parseDate(json['expiry_date']),
      visibleTime: parseDate(json['visible_time']),
      yesCount: json['yes_count'] ?? 0,
      noCount: json['no_count'] ?? 0,
    );
  }
}
