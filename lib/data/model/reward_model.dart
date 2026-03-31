class RewardModel {
  final bool status;
  final List<RewardItem>? data;
  final int monthlyRedemptions;
  final int remainingRedemptions;

  RewardModel({
    required this.status,
    required this.data,
    required this.monthlyRedemptions,
    required this.remainingRedemptions,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      status: json['status'] ?? false,
      data: json['data'] != null
          ? List<RewardItem>.from(
              json['data'].map((x) => RewardItem.fromJson(x)))
          : [],
      monthlyRedemptions: json['monthly_redemptions'] ?? 0,
      remainingRedemptions: json['remaining_redemptions'] ?? 0,
    );
  }

 
}

class RewardItem {
  final int id;
  final String image;
  final String name;
  final String description;
  final int points;
  final String expiryDate;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String imageUrl;

  RewardItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.points,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] ?? 0,
      image: json['image'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      points: json['points'] ?? 0,
      expiryDate: json['expiry_date'] ?? "",
      status: json['status'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      imageUrl: json['image_url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "description": description,
        "points": points,
        "expiry_date": expiryDate,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_url": imageUrl,
      };
}
