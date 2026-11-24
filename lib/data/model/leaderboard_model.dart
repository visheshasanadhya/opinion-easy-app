class LeaderboardModel {
  bool? success;
  String? period;
  String? date;
  List<LeaderboardUser>? data;
  LeaderboardCurrentUser? currentUser;

  LeaderboardModel({
    this.success,
    this.period,
    this.date,
    this.data,
    this.currentUser,
  });

  LeaderboardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    period = json['period'];
    date = json['date'];
    if (json['data'] != null) {
      data = <LeaderboardUser>[];
      json['data'].forEach((v) {
        data!.add(LeaderboardUser.fromJson(v));
      });
    }
    currentUser = json['current_user'] != null
        ? LeaderboardCurrentUser.fromJson(json['current_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['success'] = success;
    if (period != null) json['period'] = period;
    if (date != null) json['date'] = date;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (currentUser != null) {
      json['current_user'] = currentUser!.toJson();
    }
    return json;
  }
}

class LeaderboardUser {
  int? rank;
  int? id;
  String? name;
  String? email;
  int? points;
  String? profilePic;

  LeaderboardUser({
    this.rank,
    this.id,
    this.name,
    this.email,
    this.points,
    this.profilePic,
  });

  LeaderboardUser.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    points = json['points'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (rank != null) json['rank'] = rank;
    json['id'] = id;
    json['name'] = name;
    json['email'] = email;
    json['points'] = points;
    json['profile_pic'] = profilePic;
    return json;
  }
}

class LeaderboardCurrentUser {
  int? customerId;
  int? rank;
  int? points;

  LeaderboardCurrentUser({this.customerId, this.rank, this.points});

  LeaderboardCurrentUser.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    rank = json['rank'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (customerId != null) json['customer_id'] = customerId;
    json['rank'] = rank;
    json['points'] = points;
    return json;
  }
}

/// Backward compatibility aliases
typedef TopperModel = LeaderboardModel;
typedef TodayLeaderModel = LeaderboardModel;
typedef Data = LeaderboardUser;
typedef CurrentUser = LeaderboardCurrentUser;
