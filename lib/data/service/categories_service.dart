import 'dart:convert';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/categories_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CategoriesService {
  Future<CategoryModel> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    final url = Uri.parse(ApiEndpoints.categories);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);

    final responseData = jsonDecode(response.body);

    return CategoryModel.fromJson(responseData);
  }
}
