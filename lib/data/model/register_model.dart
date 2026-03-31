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
  String? name;
  String? phone;
  String? updatedAt;
  String? createdAt;
  int? id;

  Customer({this.name, this.phone, this.updatedAt, this.createdAt, this.id});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }
}
