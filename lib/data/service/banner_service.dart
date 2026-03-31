import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/banner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BannerService {
  Future<List<BannerModel>> fetchBanners() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("token not found re-login");
    }

    var url = Uri.parse(ApiEndpoints.banners);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print("🌅Banner response" + response.body);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch banners ${response.statusCode}");
    }
  }
}
