class BannerModel {
  final int? id;
  final String? location;
  final String? link;
  final String? expiryDate;
  final String? image;
  final String? createdAt;

  BannerModel({
    this.id,
    this.location,
    this.link,
    this.expiryDate,
    this.image,
    this.createdAt,
  });

  // Factory constructor for JSON deserialization
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      location: json['location']?.toString(),
      link: json['link']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      image: json['image']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
