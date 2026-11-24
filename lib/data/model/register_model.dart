class RegisterModel {
  bool? status;
  String? message;
  Data? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Customer? customer;
  String? token;

  Data({this.customer, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    token = json['token'];
  }
}

class Customer {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? googleId;
  String? referralCode;
  String? referredBy;
  int? points;
  int? status;
  String? profilePic;
  String? dob;
  String? createdAt;
  String? updatedAt;

  Customer({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.googleId,
    this.referralCode,
    this.referredBy,
    this.points,
    this.status,
    this.profilePic,
    this.dob,
    this.createdAt,
    this.updatedAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    phone = json['phone']?.toString();
    email = json['email']?.toString();
    googleId = json['google_id']?.toString();
    referralCode = json['referral_code']?.toString();
    referredBy = json['referred_by']?.toString();
    points = json['points'];
    status = json['status'];
    profilePic = json['profile_pic']?.toString();
    dob = json['dob']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (googleId != null) 'google_id': googleId,
      if (referralCode != null) 'referral_code': referralCode,
      if (referredBy != null) 'referred_by': referredBy,
      if (points != null) 'points': points,
      if (status != null) 'status': status,
      if (profilePic != null) 'profile_pic': profilePic,
      if (dob != null) 'dob': dob,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
