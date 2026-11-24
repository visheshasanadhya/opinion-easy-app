import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/banner_model.dart';
import 'api_client.dart';

class BannerService {
  Future<List<BannerModel>> fetchBanners() async {
    var url = Uri.parse(ApiEndpoints.banners);
    var response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch banners ${response.statusCode}");
    }
  }
}
