import 'dart:convert';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QuestionService {
  Future<List<Question>> fetchQuestion(String subCategId) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    final url = Uri.parse("${ApiEndpoints.questions}/$subCategId");
    print("url $url");

    var response = await http.get(
      url,

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("response ${response.body}");
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
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return {"status": false, "message": "Token not found, please re-login"};
    }

    final url = Uri.parse(ApiEndpoints.answer);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"question_id": questionId, "answer": answerStatus}),
    );

    return jsonDecode(response.body);
  }
}

// import 'dart:convert';
// import 'package:opinion_easy/core/api_contstant/api_constant.dart';
// import 'package:opinion_easy/data/model/question_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class QuestionService {
//   Future<List<Question>> fetchQuestion(String subCategId) async {
//     final prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//
//     if (token == null || token.isEmpty) {
//       throw Exception('Token not found');
//     }
//
//     final url = Uri.parse("${ApiEndpoints.questions}/$subCategId");
//     print("📌 URL: $url");
//
//     var response = await http.get(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     print("📌 Raw Response: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//
//       print("📌 Decoded JSON:");
//       print(data);
//
//       final questionResponse = QuestionModel.fromJson(data);
//
//       print("📌 Total Questions: ${questionResponse.questions.length}");
//
//       for (var q in questionResponse.questions) {
//         print("----------------------------------");
//         print("🆔 ID: ${q.id}");
//         print("❓ Question: ${q.question}");
//         print("----------------------------------");
//       }
//
//       return questionResponse.questions;
//     } else {
//       print("❌ Error: ${response.statusCode} -> ${response.reasonPhrase}");
//       throw Exception("Failed to load questions");
//     }
//   }
//
//   Future<Map<String, dynamic>> submitAnswer(
//     int questionId,
//     String answerStatus,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//
//     if (token == null || token.isEmpty) {
//       return {"status": false, "message": "Token not found, please re-login"};
//     }
//
//     final url = Uri.parse(ApiEndpoints.answer);
//
//     print("📩 Submitting Answer...");
//     print("➡ Question ID: $questionId");
//     print("➡ Answer: $answerStatus");
//
//     var response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({"question_id": questionId, "answer": answerStatus}),
//     );
//
//     print("📌 Submit Response: ${response.body}");
//     return jsonDecode(response.body);
//   }
// }
