// new_match_detail_model.dart - For the new API structure

class NewMatchDetailModel {
  final int seriesId;
  final String series;
  final String matchs;
  final String matchDate;
  final String matchTime;
  final int venueId;
  final String venue;
  final String place;
  final String toss;
  final String umpire;
  final String thirdUmpire;
  final String referee;
  final String matchType;
  final int matchStatus;
  final String result;
  final int teamAId;
  final String teamA;
  final String teamAShort;
  final String teamAImg;
  final int teamBId;
  final String teamB;
  final String teamBShort;
  final String teamBImg;
  final VenueWeather? venueWeather;

  NewMatchDetailModel({
    required this.seriesId,
    required this.series,
    required this.matchs,
    required this.matchDate,
    required this.matchTime,
    required this.venueId,
    required this.venue,
    required this.place,
    required this.toss,
    required this.umpire,
    required this.thirdUmpire,
    required this.referee,
    required this.matchType,
    required this.matchStatus,
    required this.result,
    required this.teamAId,
    required this.teamA,
    required this.teamAShort,
    required this.teamAImg,
    required this.teamBId,
    required this.teamB,
    required this.teamBShort,
    required this.teamBImg,
    this.venueWeather,
  });

  factory NewMatchDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return NewMatchDetailModel(
      seriesId: data['series_id'] ?? 0,
      series: data['series'] ?? '',
      matchs: data['matchs'] ?? '',
      matchDate: data['match_date'] ?? '',
      matchTime: data['match_time'] ?? '',
      venueId: data['venue_id'] ?? 0,
      venue: data['venue'] ?? '',
      place: data['place'] ?? '',
      toss: data['toss'] ?? '',
      umpire: data['umpire'] ?? '',
      thirdUmpire: data['third_umpire'] ?? '',
      referee: data['referee'] ?? '',
      matchType: data['match_type'] ?? '',
      matchStatus: data['match_status'] ?? 0,
      result: data['result'] ?? '',
      teamAId: data['team_a_id'] ?? 0,
      teamA: data['team_a'] ?? '',
      teamAShort: data['team_a_short'] ?? '',
      teamAImg: data['team_a_img'] ?? '',
      teamBId: data['team_b_id'] ?? 0,
      teamB: data['team_b'] ?? '',
      teamBShort: data['team_b_short'] ?? '',
      teamBImg: data['team_b_img'] ?? '',
      venueWeather: data['venue_weather'] != null
          ? VenueWeather.fromJson(data['venue_weather'])
          : null,
    );
  }
}

class VenueWeather {
  final String tempC;
  final String tempF;
  final String weather;
  final String weatherIcon;
  final String windMph;
  final String windKph;
  final String windDir;
  final String humidity;
  final String cloud;

  VenueWeather({
    required this.tempC,
    required this.tempF,
    required this.weather,
    required this.weatherIcon,
    required this.windMph,
    required this.windKph,
    required this.windDir,
    required this.humidity,
    required this.cloud,
  });

  factory VenueWeather.fromJson(Map<String, dynamic> json) {
    return VenueWeather(
      tempC: json['temp_c']?.toString() ?? '',
      tempF: json['temp_f']?.toString() ?? '',
      weather: json['weather'] ?? '',
      weatherIcon: json['weather_icon'] ?? '',
      windMph: json['wind_mph']?.toString() ?? '',
      windKph: json['wind_kph']?.toString() ?? '',
      windDir: json['wind_dir'] ?? '',
      humidity: json['humidity']?.toString() ?? '',
      cloud: json['cloud']?.toString() ?? '',
    );
  }
}

class NewTeamPlayerModel {
  final int playerId;
  final String name;
  final String playRole;
  final String image;
  final int isInternational;
  final String teamType; // 'team_a' or 'team_b'

  NewTeamPlayerModel({
    required this.playerId,
    required this.name,
    required this.playRole,
    required this.image,
    required this.isInternational,
    required this.teamType,
  });

  factory NewTeamPlayerModel.fromJson(
    Map<String, dynamic> json,
    String teamType,
  ) {
    return NewTeamPlayerModel(
      playerId: json['player_id'] ?? 0,
      name: json['name'] ?? '',
      playRole: json['play_role'] ?? '',
      image: json['image'] ?? '',
      isInternational: json['is_international'] ?? 0,
      teamType: teamType,
    );
  }

  bool get isInternationalPlayer => isInternational == 1;
}

class NewTeamPlayersResponse {
  final String teamAName;
  final String teamAShort;
  final String teamAFlag;
  final List<NewTeamPlayerModel> teamAPlayers;
  final String teamBName;
  final String teamBShort;
  final String teamBFlag;
  final List<NewTeamPlayerModel> teamBPlayers;

  NewTeamPlayersResponse({
    required this.teamAName,
    required this.teamAShort,
    required this.teamAFlag,
    required this.teamAPlayers,
    required this.teamBName,
    required this.teamBShort,
    required this.teamBFlag,
    required this.teamBPlayers,
  });

  factory NewTeamPlayersResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    List<NewTeamPlayerModel> teamAPlayersList = [];
    List<NewTeamPlayerModel> teamBPlayersList = [];

    if (data['team_a'] != null) {
      final teamA = data['team_a'];
      if (teamA['player'] != null) {
        for (var playerJson in teamA['player']) {
          teamAPlayersList.add(
            NewTeamPlayerModel.fromJson(playerJson, 'team_a'),
          );
        }
      }
    }

    if (data['team_b'] != null) {
      final teamB = data['team_b'];
      if (teamB['player'] != null) {
        for (var playerJson in teamB['player']) {
          teamBPlayersList.add(
            NewTeamPlayerModel.fromJson(playerJson, 'team_b'),
          );
        }
      }
    }

    return NewTeamPlayersResponse(
      teamAName: data['team_a']?['name'] ?? '',
      teamAShort: data['team_a']?['short_name'] ?? '',
      teamAFlag: data['team_a']?['flag'] ?? '',
      teamAPlayers: teamAPlayersList,
      teamBName: data['team_b']?['name'] ?? '',
      teamBShort: data['team_b']?['short_name'] ?? '',
      teamBFlag: data['team_b']?['flag'] ?? '',
      teamBPlayers: teamBPlayersList,
    );
  }
}
