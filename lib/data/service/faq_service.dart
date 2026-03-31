import 'dart:convert';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/faq_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FaqService {
  Future<List<FAQsModel>> fetchFaqs() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    final url = Uri.parse(ApiEndpoints.faqs);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body)['data'];
      return jsonList.map((json) => FAQsModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch faqs ${response.statusCode}");
    }
  }
}
