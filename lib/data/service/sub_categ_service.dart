import 'dart:convert';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/sub_categ_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubCategService {
  Future<List<SubCategModel>> fetchSubCateg(int categId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    final url = Uri.parse("${ApiEndpoints.subCategory}/$categId");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body)['data'];

      return jsonList.map((json) => SubCategModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch sub categories ${response.statusCode}");
    }
  }
}
