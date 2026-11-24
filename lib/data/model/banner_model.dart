class BannerModel {
  final int? id;
  final String? location;
  final String? link;
  final String? expiryDate;
  final String? status;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.location,
    this.link,
    this.expiryDate,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for JSON deserialization
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      location: json['location']?.toString(),
      link: json['link']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      status: json['status']?.toString(),
      image: json['image']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (location != null) 'location': location,
      if (link != null) 'link': link,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (status != null) 'status': status,
      if (image != null) 'image': image,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
