import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/topper_model.dart';
import 'api_client.dart';

class TopPerService {
  Future<TopperModel> fetchTopperList(String whichTopper) async {
    final url = Uri.parse("${ApiEndpoints.topper}?$whichTopper");
    var response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TopperModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch Topper list');
    }
  }
}
