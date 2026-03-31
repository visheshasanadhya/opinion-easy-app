class TodayLeaderModel {
  bool? success;
  List<Data>? data;
  CurrentUser? currentUser;

  TodayLeaderModel({this.success, this.data, this.currentUser});

  TodayLeaderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    currentUser = json['current_user'] != null
        ? CurrentUser.fromJson(json['current_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (currentUser != null) {
      data['current_user'] = currentUser!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  int? points;
  String? profilePic;

  Data({this.id, this.name, this.email, this.points, this.profilePic});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    points = json['points'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['points'] = points;
    data['profile_pic'] = profilePic;
    return data;
  }
}

class CurrentUser {
  int? rank;
  int? points;

  CurrentUser({this.rank, this.points});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['points'] = points;
    return data;
  }
}
