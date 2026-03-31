// match_detail_model.dart

class MatchDetailModel {
  final int matchId;
  final int seriesId;
  final String seriesName;
  final String matchDesc;
  final String matchFormat;
  final int startDate;
  final int endDate;
  final String state;
  final String status;
  final TeamInfo team1;
  final TeamInfo team2;
  final VenueInfo venueInfo;
  final String? tossStatus;
  final String? stateTitle;
  final String matchType;
  final String shortStatus;

  MatchDetailModel({
    required this.matchId,
    required this.seriesId,
    required this.seriesName,
    required this.matchDesc,
    required this.matchFormat,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.status,
    required this.team1,
    required this.team2,
    required this.venueInfo,
    this.tossStatus,
    this.stateTitle,
    required this.matchType,
    required this.shortStatus,
  });

  factory MatchDetailModel.fromJson(Map<String, dynamic> json) {
    return MatchDetailModel(
      matchId: json['match_id'] ?? 0,
      seriesId: json['series_id'] ?? 0,
      seriesName: json['seriesname'] ?? '',
      matchDesc: json['matchdesc'] ?? '',
      matchFormat: json['matchformat'] ?? '',
      startDate: _parseTimestamp(json['startdate']),
      endDate: _parseTimestamp(json['enddate']),
      state: json['state'] ?? '',
      status: json['status'] ?? '',
      team1: TeamInfo.fromJson(json['team1'] ?? {}),
      team2: TeamInfo.fromJson(json['team2'] ?? {}),
      venueInfo: VenueInfo.fromJson(json['venueinfo'] ?? {}),
      tossStatus: json['tossstatus'],
      stateTitle: json['statetitle'],
      matchType: json['matchtype'] ?? '',
      shortStatus: json['shortstatus'] ?? '',
    );
  }

  // FIXED: Handle both String and int timestamps from API
  static int _parseTimestamp(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}

class TeamInfo {
  final int teamId;
  final String teamName;
  final String teamSName;
  final bool isFullMember;
  final int imageId;

  TeamInfo({
    required this.teamId,
    required this.teamName,
    required this.teamSName,
    required this.isFullMember,
    required this.imageId,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      teamId: json['teamid'] ?? 0,
      teamName: json['teamname'] ?? '',
      teamSName: json['teamsname'] ?? '',
      isFullMember: json['isfullmember'] ?? false,
      imageId: json['imageid'] ?? 0,
    );
  }
}

class VenueInfo {
  final int id;
  final String ground;
  final String city;
  final String country;
  final String timezone;
  final String capacity;

  VenueInfo({
    required this.id,
    required this.ground,
    required this.city,
    required this.country,
    required this.timezone,
    required this.capacity,
  });

  factory VenueInfo.fromJson(Map<String, dynamic> json) {
    return VenueInfo(
      id: json['id'] ?? 0,
      ground: json['ground'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      timezone: json['timezone'] ?? '',
      capacity: json['capacity'] ?? '',
    );
  }
}

class TeamPlayerModel {
  final String id;
  final String name;
  final bool captain;
  final String role;
  final bool keeper;
  final String category;
  final int faceImageId;

  TeamPlayerModel({
    required this.id,
    required this.name,
    required this.captain,
    required this.role,
    required this.keeper,
    required this.category,
    required this.faceImageId,
  });

  factory TeamPlayerModel.fromJson(Map<String, dynamic> json, String category) {
    return TeamPlayerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      captain: json['captain'] ?? false,
      role: json['role'] ?? '',
      keeper: json['keeper'] ?? false,
      category: category,
      faceImageId: json['faceimageid'] ?? 0,
    );
  }

  String get displayName {
    String name = this.name;
    if (captain) {
      name += ' (c)';
    }
    if (keeper && !name.contains('(c)')) {
      name += ' +';
    } else if (keeper) {
      name = name.replaceAll('(c)', '+ (c)');
    }
    return name;
  }

  bool get isPlayingXI => category.toLowerCase() == 'playing xi';
}

class TeamPlayersResponse {
  final List<TeamPlayerModel> players;

  TeamPlayersResponse({required this.players});

  factory TeamPlayersResponse.fromJson(Map<String, dynamic> json) {
    List<TeamPlayerModel> allPlayers = [];

    if (json['player'] != null) {
      for (var categoryData in json['player']) {
        String category = categoryData['category'] ?? '';
        if (categoryData['player'] != null) {
          for (var playerJson in categoryData['player']) {
            allPlayers.add(TeamPlayerModel.fromJson(playerJson, category));
          }
        }
      }
    }

    return TeamPlayersResponse(players: allPlayers);
  }
}
