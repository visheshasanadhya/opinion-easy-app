import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/question_model.dart';
import 'api_client.dart';

class QuestionService {
  Future<List<Question>> fetchQuestion(String subCategId) async {
    final url = Uri.parse("${ApiEndpoints.questions}/$subCategId");
    var response = await ApiClient.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final questionResponse = QuestionModel.fromJson(data);
      return questionResponse.questions;
    } else {
      throw Exception("Failed to load questions");
    }
  }

  Future<Map<String, dynamic>> submitAnswer(
    int questionId,
    String answerStatus,
  ) async {
    final url = Uri.parse(ApiEndpoints.answer);
    var response = await ApiClient.post(
      url,
      body: jsonEncode({"question_id": questionId, "answer": answerStatus}),
    );

    return jsonDecode(response.body);
  }
}
