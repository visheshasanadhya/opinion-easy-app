import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/categories_model.dart';
import 'api_client.dart';

class CategoriesService {
  Future<CategoryModel> fetchCategories() async {
    final url = Uri.parse(ApiEndpoints.categories);
    var response = await ApiClient.get(url);

    final responseData = jsonDecode(response.body);
    return CategoryModel.fromJson(responseData);
  }
}
