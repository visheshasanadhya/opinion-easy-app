// scorecard_model.dart

class ScorecardModel {
  final String result;
  final int isHundred;
  final Map<String, InningsData> scorecard;

  ScorecardModel({
    required this.result,
    required this.isHundred,
    required this.scorecard,
  });

  factory ScorecardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    Map<String, InningsData> scorecardMap = {};
    if (data['scorecard'] != null) {
      data['scorecard'].forEach((key, value) {
        scorecardMap[key] = InningsData.fromJson(value);
      });
    }

    return ScorecardModel(
      result: data['result'] ?? '',
      isHundred: data['is_hundred'] ?? 0,
      scorecard: scorecardMap,
    );
  }
}

class InningsData {
  final TeamInnings team;
  final List<BatsmanScore> batsman;
  final List<String> yetToBat;
  final List<BowlerScore> bowler;
  final List<FallOfWicket> fallWicket;
  final List<Partnership> partnership;

  InningsData({
    required this.team,
    required this.batsman,
    required this.yetToBat,
    required this.bowler,
    required this.fallWicket,
    required this.partnership,
  });

  factory InningsData.fromJson(Map<String, dynamic> json) {
    List<BatsmanScore> batsmanList = [];
    if (json['batsman'] != null) {
      for (var item in json['batsman']) {
        batsmanList.add(BatsmanScore.fromJson(item));
      }
    }

    List<String> yetToBatList = [];
    if (json['yet_to_bet'] != null) {
      yetToBatList = List<String>.from(json['yet_to_bet']);
    }

    List<BowlerScore> bowlerList = [];
    if (json['bolwer'] != null) {
      for (var item in json['bolwer']) {
        bowlerList.add(BowlerScore.fromJson(item));
      }
    }

    List<FallOfWicket> fallWicketList = [];
    if (json['fallwicket'] != null) {
      for (var item in json['fallwicket']) {
        fallWicketList.add(FallOfWicket.fromJson(item));
      }
    }

    List<Partnership> partnershipList = [];
    if (json['partnership'] != null) {
      for (var item in json['partnership']) {
        partnershipList.add(Partnership.fromJson(item));
      }
    }

    return InningsData(
      team: TeamInnings.fromJson(json['team'] ?? {}),
      batsman: batsmanList,
      yetToBat: yetToBatList,
      bowler: bowlerList,
      fallWicket: fallWicketList,
      partnership: partnershipList,
    );
  }
}

class TeamInnings {
  final int inning;
  final int teamId;
  final String name;
  final String shortName;
  final String flag;
  final int score;
  final int wicket;
  final int testDeclare;
  final String over;
  final String extras;

  TeamInnings({
    required this.inning,
    required this.teamId,
    required this.name,
    required this.shortName,
    required this.flag,
    required this.score,
    required this.wicket,
    required this.testDeclare,
    required this.over,
    required this.extras,
  });

  factory TeamInnings.fromJson(Map<String, dynamic> json) {
    return TeamInnings(
      inning: json['inning'] ?? 0,
      teamId: json['team_id'] ?? 0,
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      flag: json['flag'] ?? '',
      score: json['score'] ?? 0,
      wicket: json['wicket'] ?? 0,
      testDeclare: json['test_declare'] ?? 0,
      over: json['over']?.toString() ?? '0',
      extras: json['extras'] ?? '',
    );
  }
}

class BatsmanScore {
  final int playerId;
  final String name;
  final int run;
  final int ball;
  final int fours;
  final int sixes;
  final String strikeRate;
  final int impactStatus;
  final String outBy;

  BatsmanScore({
    required this.playerId,
    required this.name,
    required this.run,
    required this.ball,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.impactStatus,
    required this.outBy,
  });

  factory BatsmanScore.fromJson(Map<String, dynamic> json) {
    return BatsmanScore(
      playerId: json['player_id'] ?? 0,
      name: json['name'] ?? '',
      run: json['run'] ?? 0,
      ball: json['ball'] ?? 0,
      fours: json['fours'] ?? 0,
      sixes: json['sixes'] ?? 0,
      strikeRate: json['strike_rate']?.toString() ?? '0',
      impactStatus: json['impact_status'] ?? 0,
      outBy: json['out_by'] ?? '',
    );
  }

  bool get isNotOut => outBy.toLowerCase().contains('not out');
}

class BowlerScore {
  final int playerId;
  final String name;
  final String over;
  final int maiden;
  final int run;
  final int wicket;
  final String economy;
  final int dotBall;
  final int wide;
  final int noBall;

  BowlerScore({
    required this.playerId,
    required this.name,
    required this.over,
    required this.maiden,
    required this.run,
    required this.wicket,
    required this.economy,
    required this.dotBall,
    required this.wide,
    required this.noBall,
  });

  factory BowlerScore.fromJson(Map<String, dynamic> json) {
    return BowlerScore(
      playerId: json['player_id'] ?? 0,
      name: json['name'] ?? '',
      over: json['over']?.toString() ?? '0',
      maiden: json['maiden'] ?? 0,
      run: json['run'] ?? 0,
      wicket: json['wicket'] ?? 0,
      economy: json['economy']?.toString() ?? '0',
      dotBall: json['dot_ball'] ?? 0,
      wide: json['wide'] ?? 0,
      noBall: json['no_ball'] ?? 0,
    );
  }
}

class FallOfWicket {
  final String player;
  final String score;
  final String wicket;
  final String over;

  FallOfWicket({
    required this.player,
    required this.score,
    required this.wicket,
    required this.over,
  });

  factory FallOfWicket.fromJson(Map<String, dynamic> json) {
    return FallOfWicket(
      player: json['player'] ?? '',
      score: json['score']?.toString() ?? '0',
      wicket: json['wicket']?.toString() ?? '0',
      over: json['over']?.toString() ?? '0',
    );
  }
}

class Partnership {
  final int playerAId;
  final int playerBId;
  final String playersName;
  final int run;
  final int ball;
  final String playerAName;
  final int playerARun;
  final int playerABall;
  final String playerBName;
  final int playerBRun;
  final int playerBBall;

  Partnership({
    required this.playerAId,
    required this.playerBId,
    required this.playersName,
    required this.run,
    required this.ball,
    required this.playerAName,
    required this.playerARun,
    required this.playerABall,
    required this.playerBName,
    required this.playerBRun,
    required this.playerBBall,
  });

  factory Partnership.fromJson(Map<String, dynamic> json) {
    return Partnership(
      playerAId: json['player_a_id'] ?? 0,
      playerBId: json['player_b_id'] ?? 0,
      playersName: json['players_name'] ?? '',
      run: json['run'] ?? 0,
      ball: json['ball'] ?? 0,
      playerAName: json['player_a_name'] ?? '',
      playerARun: json['player_a_run'] ?? 0,
      playerABall: json['player_a_ball'] ?? 0,
      playerBName: json['player_b_name'] ?? '',
      playerBRun: json['player_b_run'] ?? 0,
      playerBBall: json['player_b_ball'] ?? 0,
    );
  }
}
