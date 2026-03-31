class TopperModel {
  bool? success;
  List<Data>? data;
  CurrentUser? currentUser;

  TopperModel({this.success, this.data, this.currentUser});

  TopperModel.fromJson(Map<String, dynamic> json) {
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
}

class CurrentUser {
  int? rank;
  int? points;

  CurrentUser({this.rank, this.points});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    points = json['points'];
  }
}
