// FILE 3: cricket_service.dart
// ========================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_contstant/api_constant.dart';
import '../model/cricket_match_model.dart';

class CricketService {
  /// Helper to get Headers with Token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Fetch all cricket matches
  Future<CricketResponse> getAllMatches() async {
    try {
      final headers = await _getHeaders();

      final response = await http
          .get(Uri.parse(ApiEndpoints.allMatchesEndpoint), headers: headers)
          .timeout(const Duration(seconds: 30));

      // Debug Logs
      print('URL => ${ApiEndpoints.allMatchesEndpoint}');
      print('STATUS CODE => ${response.statusCode}');
      print('RESPONSE BODY => ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CricketResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to load matches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<List<CricketMatchModel>> getLiveMatches() async {
    final response = await getAllMatches();
    return response.matches.where((m) => m.isLive).toList();
  }

  Future<List<CricketMatchModel>> getUpcomingMatches() async {
    final response = await getAllMatches();
    return response.matches.where((m) => m.isUpcoming).toList();
  }

  Future<List<CricketMatchModel>> getResultMatches() async {
    final response = await getAllMatches();
    return response.matches.where((m) => m.isResult).toList();
  }
}
