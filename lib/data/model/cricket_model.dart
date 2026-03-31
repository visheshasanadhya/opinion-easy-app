import 'package:flutter/material.dart';

class LiveMatchModel {
  // Match / Series
  final int? matchId;
  final int? seriesId;
  final bool isHundred;
  final bool isScorecard;
  final String series;
  final String? seriesType;
  final String matchStatus;
  final String? matchType;
  final String? matchNumber;

  // Date & Time
  final String? matchDate;
  final String? matchTime;
  final DateTime? startTime;

  // Venue
  final int? venueId;
  final String? venue;

  // Toss / Result
  final String? toss;
  final String? result;

  // Teams
  final int? teamAId;
  final String teamAName;
  final String teamAShort;
  final String? teamAImg;

  final int? teamBId;
  final String teamBName;
  final String teamBShort;
  final String? teamBImg;

  // Scores
  final String teamAScore;
  final String teamAOver;
  final int? teamAWickets;

  final String teamBScore;
  final String teamBOver;
  final int? teamBWickets;

  // Live State
  final String? battingTeam;
  final String? bowlingTeam;
  final String? currentInning;

  // Match Info
  final String? needRunBall;
  final String? trailLead;
  final String? favTeam;

  // Rates / Odds
  final double? minRate;
  final double? maxRate;
  final String? minRate1;
  final String? maxRate1;
  final String? minRate2;
  final String? maxRate2;

  // Session
  final String? sessionOver;
  final String? sessionMin;
  final String? sessionMax;

  // UI Helpers
  final bool isLive;
  final String? stateTitle;

  LiveMatchModel({
    this.matchId,
    this.seriesId,
    this.isHundred = false,
    this.isScorecard = false,
    required this.series,
    this.seriesType,
    required this.matchStatus,
    this.matchType,
    this.matchNumber,
    this.matchDate,
    this.matchTime,
    this.startTime,
    this.venueId,
    this.venue,
    this.toss,
    this.result,
    this.teamAId,
    required this.teamAName,
    required this.teamAShort,
    this.teamAImg,
    this.teamBId,
    required this.teamBName,
    required this.teamBShort,
    this.teamBImg,
    required this.teamAScore,
    required this.teamAOver,
    this.teamAWickets,
    required this.teamBScore,
    required this.teamBOver,
    this.teamBWickets,
    this.battingTeam,
    this.bowlingTeam,
    this.currentInning,
    this.needRunBall,
    this.trailLead,
    this.favTeam,
    this.minRate,
    this.maxRate,
    this.minRate1,
    this.maxRate1,
    this.minRate2,
    this.maxRate2,
    this.sessionOver,
    this.sessionMin,
    this.sessionMax,
    this.isLive = false,
    this.stateTitle,
  });

  // -------------------- API MAPPER --------------------

  factory LiveMatchModel.fromApiJson(Map<String, dynamic> json) {
    final toss = json['toss']?.toString() ?? '';
    final result = json['result']?.toString() ?? '';

    return LiveMatchModel(
      matchId: json['match_id'],
      seriesId: json['series_id'],
      isHundred: json['is_hundred'] == 1,
      isScorecard: json['is_scorecard'] == 1,
      series: json['series']?.toString() ?? '',
      seriesType: json['series_type']?.toString(),
      matchStatus: json['match_status']?.toString() ?? '',
      matchType: json['match_type']?.toString(),
      matchNumber: json['matchs']?.toString(),
      matchDate: json['match_date']?.toString(),
      matchTime: json['match_time']?.toString(),
      startTime: _parseDateTime(
        json['match_date']?.toString(),
        json['match_time']?.toString(),
      ),
      venueId: json['venue_id'],
      venue: json['venue']?.toString(),
      toss: toss.isNotEmpty ? toss : null,
      result: result.isNotEmpty ? result : null,

      teamAId: json['team_a_id'],
      teamAName: json['team_a']?.toString() ?? '',
      teamAShort: json['team_a_short']?.toString() ?? '',
      teamAImg: json['team_a_img']?.toString(),

      teamBId: json['team_b_id'],
      teamBName: json['team_b']?.toString() ?? '',
      teamBShort: json['team_b_short']?.toString() ?? '',
      teamBImg: json['team_b_img']?.toString(),

      teamAScore: json['team_a_scores']?.toString() ?? '',
      teamAOver: json['team_a_over']?.toString() ?? '',
      teamAWickets: _extractWickets(json['team_a_scores']?.toString()),

      teamBScore: json['team_b_scores']?.toString() ?? '',
      teamBOver: json['team_b_over']?.toString() ?? '',
      teamBWickets: _extractWickets(json['team_b_scores']?.toString()),

      battingTeam: json['batting_team']?.toString(),
      bowlingTeam: json['balling_team']?.toString(),
      currentInning: json['current_inning']?.toString(),

      needRunBall: json['need_run_ball']?.toString(),
      trailLead: json['trail_lead']?.toString(),
      favTeam: json['fav_team']?.toString(),

      minRate: (json['min_rate'] as num?)?.toDouble(),
      maxRate: (json['max_rate'] as num?)?.toDouble(),
      minRate1: json['min_rate_1']?.toString(),
      maxRate1: json['max_rate_1']?.toString(),
      minRate2: json['min_rate_2']?.toString(),
      maxRate2: json['max_rate_2']?.toString(),

      sessionOver: json['s_ovr']?.toString(),
      sessionMin: json['s_min']?.toString(),
      sessionMax: json['s_max']?.toString(),

      isLive: json['match_status']?.toString() == 'Live',
      stateTitle: _getStateTitle(
        toss,
        result,
        json['team_a_scores']?.toString(),
        json['team_b_scores']?.toString(),
      ),
    );
  }

  // -------------------- HELPERS --------------------

  static int? _extractWickets(String? score) {
    if (score == null || score.isEmpty) return null;
    final parts = score.split('-');
    if (parts.length == 2) {
      return int.tryParse(parts[1]);
    }
    return null;
  }

  static DateTime? _parseDateTime(String? dateStr, String? timeStr) {
    if (dateStr == null || timeStr == null) return null;

    try {
      final dateParts = dateStr.split('-');
      final day = int.parse(dateParts[0]);
      final monthMap = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };
      final month = monthMap[dateParts[1]] ?? 1;
      final year = DateTime.now().year;

      final match = RegExp(r'(\d+):(\d+)\s*(AM|PM)').firstMatch(timeStr);
      if (match == null) return null;

      int hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!;

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  static String? _getStateTitle(
    String toss,
    String result,
    String? teamAScore,
    String? teamBScore,
  ) {
    if (toss.isNotEmpty &&
        (teamAScore == null || teamAScore.isEmpty) &&
        (teamBScore == null || teamBScore.isEmpty)) {
      return 'TOSS';
    }
    if (result.isNotEmpty) {
      return 'RESULT';
    }
    return null;
  }
}

class UpcomingMatchModel {
  // Match / Series
  final int matchId;
  final int seriesId;
  final String series;
  final String? seriesType;
  final String matchType;
  final String matchStatus;
  final String matchNumber;

  // Date & Time
  final String dateWise;
  final String matchDate;
  final String matchTime;
  final DateTime? startTime;

  // Venue
  final int venueId;
  final String venue;

  // Flags
  final bool isHundred;

  // Favourite / Odds
  final String favTeam;
  final double minRate;
  final double maxRate;

  // Team A
  final int teamAId;
  final String teamAName;
  final String teamAShort;
  final String teamAImg;

  // Team B
  final int teamBId;
  final String teamBName;
  final String teamBShort;
  final String teamBImg;

  // UI Helpers
  final bool isUpcoming;

  UpcomingMatchModel({
    required this.matchId,
    required this.seriesId,
    required this.series,
    this.seriesType,
    required this.matchType,
    required this.matchStatus,
    required this.matchNumber,
    required this.dateWise,
    required this.matchDate,
    required this.matchTime,
    this.startTime,
    required this.venueId,
    required this.venue,
    required this.isHundred,
    required this.favTeam,
    required this.minRate,
    required this.maxRate,
    required this.teamAId,
    required this.teamAName,
    required this.teamAShort,
    required this.teamAImg,
    required this.teamBId,
    required this.teamBName,
    required this.teamBShort,
    required this.teamBImg,
    required this.isUpcoming,
  });

  // ---------------- API MAPPER ----------------

  factory UpcomingMatchModel.fromApiJson(Map<String, dynamic> json) {
    return UpcomingMatchModel(
      matchId: json['match_id'],
      seriesId: json['series_id'],
      series: json['series'] ?? '',
      seriesType: json['series_type'],
      matchType: json['match_type'] ?? '',
      matchStatus: json['match_status'] ?? '',
      matchNumber: json['matchs'] ?? '',
      dateWise: json['date_wise'] ?? '',
      matchDate: json['match_date'] ?? '',
      matchTime: json['match_time'] ?? '',
      startTime: _parseDateTime(json['match_date'], json['match_time']),
      venueId: json['venue_id'],
      venue: json['venue'] ?? '',
      isHundred: json['is_hundred'] == 1,
      favTeam: json['fav_team'] ?? '',
      minRate: double.tryParse(json['min_rate']?.toString() ?? '0') ?? 0,
      maxRate: double.tryParse(json['max_rate']?.toString() ?? '0') ?? 0,
      teamAId: json['team_a_id'],
      teamAName: json['team_a'] ?? '',
      teamAShort: json['team_a_short'] ?? '',
      teamAImg: json['team_a_img'] ?? '',
      teamBId: json['team_b_id'],
      teamBName: json['team_b'] ?? '',
      teamBShort: json['team_b_short'] ?? '',
      teamBImg: json['team_b_img'] ?? '',
      isUpcoming: json['match_status'] == 'Upcoming',
    );
  }

  // ---------------- HELPERS ----------------

  static DateTime? _parseDateTime(String? dateStr, String? timeStr) {
    if (dateStr == null || timeStr == null) return null;

    try {
      final dateParts = dateStr.split('-');
      final day = int.parse(dateParts[0]);

      final monthMap = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };

      final month = monthMap[dateParts[1]] ?? 1;
      final year = DateTime.now().year;

      final match = RegExp(r'(\d+):(\d+)\s*(AM|PM)').firstMatch(timeStr);
      if (match == null) return null;

      int hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!;

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }
}
