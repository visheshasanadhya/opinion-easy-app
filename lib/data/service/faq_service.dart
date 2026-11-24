import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/faq_model.dart';
import 'api_client.dart';

class FaqService {
  Future<List<FAQsModel>> fetchFaqs() async {
    final url = Uri.parse(ApiEndpoints.faqs);
    var response = await ApiClient.getPublic(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body)['data'];
      return jsonList.map((json) => FAQsModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch faqs ${response.statusCode}");
    }
  }
}
