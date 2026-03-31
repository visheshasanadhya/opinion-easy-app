import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/model/scorecard_model.dart';
import '../../data/model/new_match_detail_model.dart';

class NewMatchDetailController extends GetxController {
  final String matchId;

  NewMatchDetailController({required this.matchId});

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rx<NewMatchDetailModel?> matchDetail = Rx<NewMatchDetailModel?>(null);
  var teamAPlayers = <NewTeamPlayerModel>[].obs;
  var teamBPlayers = <NewTeamPlayerModel>[].obs;
  var selectedTeam = 'team_a'.obs; // 'team_a' or 'team_b'

  // Scorecard variables
  Rx<ScorecardModel?> scorecard = Rx<ScorecardModel?>(null);
  var isScorecardLoading = false.obs;
  var selectedTab = 0.obs; // 0: Squad, 1: Scorecard

  @override
  void onInit() {
    super.onInit();
    fetchMatchDetail();
    fetchScorecard();
  }

  Future<void> fetchMatchDetail() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('Fetching new match details for matchId: $matchId');
      final url =
          'https://admin.dailyopinion.in/api/customer/cricket/match/$matchId';
      print('URL: $url');

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. Please re-login.");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          // Handle nested data structure
          final innerData = data['data'];
          if (innerData['status'] == true) {
            matchDetail.value = NewMatchDetailModel.fromJson(innerData);
            print('Match details loaded successfully');

            // Fetch team players
            await fetchTeamPlayers();

            isLoading.value = false;
          } else {
            throw Exception(innerData['msg'] ?? 'API returned status false');
          }
        } else {
          throw Exception(data['message'] ?? 'API returned status false');
        }
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e, stackTrace) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
      print('Error fetching match details: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> fetchTeamPlayers() async {
    try {
      print('Fetching team players for matchId: $matchId');

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. Please re-login.");
      }

      final response = await http.get(
        Uri.parse(
          'https://admin.dailyopinion.in/api/customer/cricket/team/$matchId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Team players response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final innerData = data['data'];
          if (innerData['status'] == true) {
            final playersResponse = NewTeamPlayersResponse.fromJson(innerData);
            teamAPlayers.value = playersResponse.teamAPlayers;
            teamBPlayers.value = playersResponse.teamBPlayers;
            print('Loaded ${teamAPlayers.length} players for Team A');
            print('Loaded ${teamBPlayers.length} players for Team B');
          }
        }
      }
    } catch (e) {
      print('Error fetching team players: $e');
    }
  }

  Future<void> fetchScorecard() async {
    try {
      isScorecardLoading.value = true;
      print('Fetching scorecard for matchId: $matchId');

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. Please re-login.");
      }

      final response = await http.get(
        Uri.parse(
          'https://admin.dailyopinion.in/api/customer/cricket/scorecard/$matchId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Scorecard response status: ${response.statusCode}');
      print('Scorecard response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final innerData = data['data'];
          if (innerData['status'] == true) {
            scorecard.value = ScorecardModel.fromJson(innerData['data']);
            print('Scorecard loaded successfully');
          }
        }
      }
    } catch (e) {
      print('Error fetching scorecard: $e');
    } finally {
      isScorecardLoading.value = false;
    }
  }

  List<NewTeamPlayerModel> get currentTeamPlayers {
    return selectedTeam.value == 'team_a' ? teamAPlayers : teamBPlayers;
  }

  String get currentTeamName {
    if (matchDetail.value == null) return '';
    return selectedTeam.value == 'team_a'
        ? matchDetail.value!.teamA
        : matchDetail.value!.teamB;
  }

  String get currentTeamShort {
    if (matchDetail.value == null) return '';
    return selectedTeam.value == 'team_a'
        ? matchDetail.value!.teamAShort
        : matchDetail.value!.teamBShort;
  }

  void switchTeam(String team) {
    selectedTeam.value = team; // 'team_a' or 'team_b'
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  Future<void> retry() async {
    await fetchMatchDetail();
    await fetchScorecard();
  }

  String getMatchStatusText() {
    if (matchDetail.value == null) return '';

    final match = matchDetail.value!;
    if (match.result.isNotEmpty) {
      return match.result;
    }

    switch (match.matchStatus) {
      case 0:
        return 'Upcoming';
      case 1:
        return 'Live';
      case 2:
        return 'In Progress';
      case 3:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}
