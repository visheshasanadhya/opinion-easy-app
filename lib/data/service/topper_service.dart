import 'dart:convert';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/topper_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TopPerService {
  Future<TopperModel> fetchTopperList(String whichTopper) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    final url = Uri.parse("${ApiEndpoints.topper}?$whichTopper");
    print("url $url");

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
      return TopperModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch Topper list');
    }
  }
}
