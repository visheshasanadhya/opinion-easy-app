import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import '../model/today_leader_model.dart';
import 'api_client.dart';

class TodayLeaderService {
  Future<TodayLeaderModel> fetchTodayLeaderList(String whichLeader) async {
    final url = Uri.parse(ApiEndpoints.todayLeader);
    var response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TodayLeaderModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch Today Leader list');
    }
  }
}
