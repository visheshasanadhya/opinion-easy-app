import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryService {
  Future<Map<String, List>> fetchHistory({int page = 1}) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    final url = Uri.parse("${ApiEndpoints.history}?page=$page");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final answers = data['answers'] as List;
      final redeemRequests = data['redeem_requests'] as List;

      return {
        "answers": answers.map((json) => HistoryModel.fromJson(json)).toList(),
        "redeem_requests": redeemRequests
            .map((json) => RedeemModel.fromJson(json))
            .toList(),
      };
    } else {
      throw Exception('Failed to fetch history');
    }
  }
}
