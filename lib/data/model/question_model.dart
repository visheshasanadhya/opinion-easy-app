class QuestionModel {
  final String status;
  final List<Question> questions;

  QuestionModel({required this.status, required this.questions});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      status: json['status'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PollResult {
  final int yesCount;
  final int noCount;
  final int totalVotes;
  final double yesPercentage;
  final double noPercentage;
  final String winChoice;

  PollResult({
    required this.yesCount,
    required this.noCount,
    required this.totalVotes,
    required this.yesPercentage,
    required this.noPercentage,
    required this.winChoice,
  });

  /// Ratio for Progress Bar (0.0 to 1.0)
  double get yesRatio => totalVotes == 0 ? 0.0 : (yesCount / totalVotes);
  double get noRatio => totalVotes == 0 ? 0.0 : (noCount / totalVotes);

  factory PollResult.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      return int.tryParse(val?.toString() ?? '0') ?? 0;
    }

    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is num) return val.toDouble();
      return double.tryParse(val?.toString() ?? '0.0') ?? 0.0;
    }

    final yes = parseInt(json['yes_count']);
    final no = parseInt(json['no_count']);
    final total = parseInt(json['total_votes']) > 0
        ? parseInt(json['total_votes'])
        : (yes + no);

    final yesPct = json['yes_percentage'] != null
        ? parseDouble(json['yes_percentage'])
        : (total > 0 ? ((yes / total) * 100) : 0.0);

    final noPct = json['no_percentage'] != null
        ? parseDouble(json['no_percentage'])
        : (total > 0 ? ((no / total) * 100) : 0.0);

    final win = json['win_choice']?.toString() ??
        (yes > no ? 'Yes' : (no > yes ? 'No' : (total > 0 ? 'Tie' : 'None')));

    return PollResult(
      yesCount: yes,
      noCount: no,
      totalVotes: total,
      yesPercentage: yesPct,
      noPercentage: noPct,
      winChoice: win,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yes_count': yesCount,
      'no_count': noCount,
      'total_votes': totalVotes,
      'yes_percentage': yesPercentage,
      'no_percentage': noPercentage,
      'win_choice': winChoice,
    };
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
  final String? userAnswer;
  final PollResult? pollResult;
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
    this.userAnswer,
    this.pollResult,
    this.yesCount = 0,
    this.noCount = 0,
  });

  bool get isAnswered => userAnswer != null && userAnswer!.trim().isNotEmpty;

  Question copyWith({
    String? userAnswer,
    PollResult? pollResult,
    int? yesCount,
    int? noCount,
  }) {
    return Question(
      id: id,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      question: question,
      points: points,
      attempPoint: attempPoint,
      bannerLink: bannerLink,
      bannerImage: bannerImage,
      answerStatus: answerStatus,
      notificationSent: notificationSent,
      createdAt: createdAt,
      updatedAt: updatedAt,
      expiryDate: expiryDate,
      visibleTime: visibleTime,
      userAnswer: userAnswer ?? this.userAnswer,
      pollResult: pollResult ?? this.pollResult,
      yesCount: yesCount ?? this.yesCount,
      noCount: noCount ?? this.noCount,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    final pollJson = json['poll_result'];
    final poll = pollJson != null && pollJson is Map<String, dynamic>
        ? PollResult.fromJson(pollJson)
        : null;

    final yes = json['yes_count'] is int
        ? json['yes_count'] as int
        : (poll?.yesCount ?? 0);
    final no = json['no_count'] is int
        ? json['no_count'] as int
        : (poll?.noCount ?? 0);

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
      userAnswer: json['user_answer']?.toString(),
      pollResult: poll,
      yesCount: yes,
      noCount: no,
    );
  }
}
