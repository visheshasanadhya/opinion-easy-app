import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/history_model.dart';
import 'api_client.dart';

class HistoryService {
  Future<Map<String, List>> fetchHistory({
    int page = ApiEndpoints.startPagination,
    int limit = ApiEndpoints.limitPagination,
  }) async {
    final url = Uri.parse("${ApiEndpoints.history}?start=$page&limit=$limit");
    var response = await ApiClient.get(url);

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
