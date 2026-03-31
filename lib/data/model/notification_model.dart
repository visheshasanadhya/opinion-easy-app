class NotificationModel {
  final int id;
  final int customerId;
  final String title;
  final String message;
  final String type;
  bool isRead;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final NotificationData? data;

  NotificationModel({
    required this.id,
    required this.customerId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    NotificationData? notificationData;

    if (rawData is Map<String, dynamic>) {
      notificationData = NotificationData.fromJson(rawData);
    } else {
      notificationData = null;
    }

    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      customerId: json['customer_id'] is int
          ? json['customer_id']
          : int.parse(json['customer_id'].toString()),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      // Ensure boolean handling is safe
      isRead: json['is_read'] is bool ? json['is_read'] : false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      data: notificationData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customer_id": customerId,
      "title": title,
      "message": message,
      "type": type,
      "is_read": isRead,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "data": data?.toJson(),
    };
  }
}

/// -----------------------------------------------------------------------------

class NotificationData {
  final String? bannerLink;
  final String? categoryId;
  final String? questionId;
  final String? subcategoryId;

  NotificationData({
    this.bannerLink,
    this.categoryId,
    this.questionId,
    this.subcategoryId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      bannerLink: json['banner_link'],
      categoryId: json['category_id']?.toString(),
      questionId: json['question_id']?.toString(),
      subcategoryId: json['subcategory_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "banner_link": bannerLink,
      "category_id": categoryId,
      "question_id": questionId,
      "subcategory_id": subcategoryId,
    };
  }
}
