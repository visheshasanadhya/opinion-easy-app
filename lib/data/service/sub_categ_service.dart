import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/sub_categ_model.dart';
import 'api_client.dart';

class SubCategService {
  Future<List<SubCategModel>> fetchSubCateg(int categId) async {
    final url = Uri.parse("${ApiEndpoints.subCategory}/$categId");
    var response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body)['data'];
      return jsonList.map((json) => SubCategModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch sub categories ${response.statusCode}");
    }
  }
}
