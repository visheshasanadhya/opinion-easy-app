import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/leaderboard_model.dart';
import 'api_client.dart';

class LeaderboardService {
  /// Fetch today's top earners / leaders
  Future<LeaderboardModel> fetchTodayLeaders({
    int start = ApiEndpoints.startPagination,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    final url = Uri.parse(
      "${ApiEndpoints.todayLeader}?start=$start&limit=$limit",
    );
    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LeaderboardModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch today leaderboard');
    }
  }

  /// Fetch monthly top performers
  Future<LeaderboardModel> fetchMonthlyLeaders({
    int start = ApiEndpoints.startPagination,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    final url = Uri.parse(
      "${ApiEndpoints.topper}?period=month&start=$start&limit=$limit",
    );
    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LeaderboardModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch monthly leaderboard');
    }
  }

  /// Fetch all-time top performers
  Future<LeaderboardModel> fetchAllTimeLeaders({
    int start = ApiEndpoints.startPagination,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    final url = Uri.parse(
      "${ApiEndpoints.topper}?start=$start&limit=$limit",
    );
    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LeaderboardModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch all-time leaderboard');
    }
  }

  /// Backward-compatible method for TopperService
  Future<LeaderboardModel> fetchTopperList(
    String whichTopper, {
    int start = ApiEndpoints.startPagination,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    if (whichTopper == "month") {
      return fetchMonthlyLeaders(start: start, limit: limit);
    }
    if (whichTopper == "today") {
      return fetchTodayLeaders(start: start, limit: limit);
    }
    return fetchAllTimeLeaders(start: start, limit: limit);
  }

  /// Backward-compatible method for TodayLeaderService
  Future<LeaderboardModel> fetchTodayLeaderList(
    String whichLeader, {
    int start = ApiEndpoints.startPagination,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    return fetchTodayLeaders(start: start, limit: limit);
  }
}

/// Backward compatibility aliases
typedef TopperService = LeaderboardService;
typedef TodayLeaderService = LeaderboardService;
