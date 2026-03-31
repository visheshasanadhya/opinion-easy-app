class CricketMatchModel {
  final String id;
  final String dateTimeGMT;
  final String matchType;
  final String status;
  final String ms; // fixture | live | result
  final String t1;
  final String t2;
  final String t1s;
  final String t2s;
  final String? t1img;
  final String? t2img;
  final String series;

  CricketMatchModel({
    required this.id,
    required this.dateTimeGMT,
    required this.matchType,
    required this.status,
    required this.ms,
    required this.t1,
    required this.t2,
    required this.t1s,
    required this.t2s,
    this.t1img,
    this.t2img,
    required this.series,
  });

  factory CricketMatchModel.fromJson(Map<String, dynamic> json) {
    return CricketMatchModel(
      id: json['id'] ?? '',
      dateTimeGMT: json['dateTimeGMT'] ?? '',
      matchType: json['matchType'] ?? '',
      status: json['status'] ?? '',
      ms: json['ms'] ?? '',
      t1: json['t1'] ?? '',
      t2: json['t2'] ?? '',
      t1s: json['t1s'] ?? '',
      t2s: json['t2s'] ?? '',
      t1img: json['t1img'],
      t2img: json['t2img'],
      series: json['series'] ?? '',
    );
  }

  // ================= MATCH STATE =================
  bool get isLive => ms == 'live';
  bool get isUpcoming => ms == 'fixture';
  bool get isResult => ms == 'result';

  // ================= TIME HANDLING =================

  /// Parsed GMT time from API
  DateTime? get matchDateTimeGMTParsed {
    try {
      // Remove 'Z' if present and parse as UTC
      String dateStr = dateTimeGMT.replaceAll('Z', '');
      DateTime parsedDate = DateTime.parse(dateStr);

      // Ensure it's treated as UTC
      if (!parsedDate.isUtc) {
        parsedDate = DateTime.utc(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          parsedDate.hour,
          parsedDate.minute,
          parsedDate.second,
        );
      }

      return parsedDate;
    } catch (e) {
      print('Error parsing GMT time: $e');
      return null;
    }
  }

  /// Converted IST time (GMT/UTC + 5:30)
  /// IST = Indian Standard Time (UTC+05:30)
  DateTime? get matchDateTimeIST {
    final gmt = matchDateTimeGMTParsed;
    if (gmt == null) return null;

    // Convert UTC to IST by adding 5 hours and 30 minutes
    // IST offset = UTC+05:30
    final istTime = gmt.add(const Duration(hours: 5, minutes: 30));

    return istTime;
  }

  /// Get formatted IST time string (e.g., "3:30 PM IST")
  String get formattedISTTime {
    final istTime = matchDateTimeIST;
    if (istTime == null) return '';

    final hour = istTime.hour % 12 == 0 ? 12 : istTime.hour % 12;
    final minute = istTime.minute.toString().padLeft(2, '0');
    final period = istTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period IST';
  }

  /// Get formatted IST date string (e.g., "Dec 27, 2025")
  String get formattedISTDate {
    final istTime = matchDateTimeIST;
    if (istTime == null) return '';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[istTime.month - 1]} ${istTime.day}, ${istTime.year}';
  }

  // ================= TEAM HELPERS =================
  String get team1Short =>
      RegExp(r'\[([^\]]+)\]').firstMatch(t1)?.group(1) ?? t1;

  String get team2Short =>
      RegExp(r'\[([^\]]+)\]').firstMatch(t2)?.group(1) ?? t2;

  // ================= SCORE HELPERS =================
  String get team1ScoreClean =>
      t1s.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();

  String get team2ScoreClean =>
      t2s.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();

  String get team1Overs =>
      RegExp(r'\(([^)]+)\)').firstMatch(t1s)?.group(1) ?? '';

  String get team2Overs =>
      RegExp(r'\(([^)]+)\)').firstMatch(t2s)?.group(1) ?? '';
}

// ================= RESPONSE =================

class CricketResponse {
  final bool status;
  final String message;
  final List<CricketMatchModel> matches;

  CricketResponse({
    required this.status,
    required this.message,
    required this.matches,
  });

  factory CricketResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data']?['data'] as List? ?? [];
    return CricketResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      matches: data.map((e) => CricketMatchModel.fromJson(e)).toList(),
    );
  }
}
