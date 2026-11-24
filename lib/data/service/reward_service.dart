import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/reward_model.dart';
import 'api_client.dart';

class RewardService {
  Future<RewardModel> fetchRewards() async {
    final url = Uri.parse(ApiEndpoints.rewards);
    final response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return RewardModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load rewards');
    }
  }

  Future<Map<String, dynamic>> redeem(int rewardId) async {
    final url = Uri.parse("${ApiEndpoints.redeem}/$rewardId");
    final response = await ApiClient.get(url);
    final responseData = jsonDecode(response.body);
    return responseData;
  }
}
