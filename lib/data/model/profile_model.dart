class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? name;
  String? phone;
  int? status;
  String? email;
  String? refferalCode;
  String? refferedBy;
  int? points;
  String? dob;
  String? profilePic;
  String? createdAt;
  String? updatedAt;
  Address? address;

  Data({
    this.id,
    this.name,
    this.phone,
    this.status,
    this.refferalCode,
    this.refferedBy,
    this.email,
    this.dob,
    this.points,
    this.profilePic,
    this.createdAt,
    this.updatedAt,
    this.address,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points'];
    name = json['name'].toString();
    phone = json['phone'].toString();
    email = json['email'] != null ? json['email'].toString() : "user@email.com";
    refferalCode = json['referral_code'] != null
        ? json['referral_code'].toString()
        : "NA";
    refferedBy = json['referred_by'] != null
        ? json['referred_by'].toString()
        : "Unknown";
    status = json['status'];
    dob = json['dob'] != null ? json['dob'].toString() : "Enter DOB";
    profilePic = json['profile_pic'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    address = json['address'] != null
        ? Address.fromJson(json['address'])
        : null;
  }
}

class Address {
  int? id;
  int? customerId;
  String? state;
  String? district;
  String? city;
  String? pincode;
  String? address;
  String? createdAt;
  String? updatedAt;

  Address({
    this.id,
    this.customerId,
    this.state,
    this.district,
    this.city,
    this.pincode,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    state = json['state'].toString();
    district = json['district'].toString();
    city = json['city'].toString();
    pincode = json['pincode'].toString();
    address = json['address'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }
}
