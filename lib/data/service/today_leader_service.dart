import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/today_leader_model.dart';

class TodayLeaderService {
  Future<TodayLeaderModel> fetchTodayLeaderList(String whichLeader) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    //final url = Uri.parse("${ApiEndpoints.todayLeader}?$whichLeader");
    final url = Uri.parse(ApiEndpoints.todayLeader);
    // print("url $url");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("res ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TodayLeaderModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch Today Leader list');
    }
  }
}
