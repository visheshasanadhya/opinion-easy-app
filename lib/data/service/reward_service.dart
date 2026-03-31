import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/reward_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RewardService {
  Future<RewardModel> fetchRewards() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(ApiEndpoints.rewards);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      //List<dynamic> jsonData = responseData['data'];
      //return jsonData.map((json) => RewardModel.fromJson(json)).toList();

      return RewardModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load rewards');
    }
  }

  Future<Map<String, dynamic>> redeem(int rewardId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final url = Uri.parse("${ApiEndpoints.redeem}/$rewardId");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);
    return responseData;
  }
}
