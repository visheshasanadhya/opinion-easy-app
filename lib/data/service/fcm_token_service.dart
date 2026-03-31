import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenService {
  static Future<Map<String, dynamic>> saveFCMToken(String fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("tokenn $token");

    if (token == null || token.isEmpty) {
      return {"status": false, "message": "Token not found, please re-login"};
    }

    final url = Uri.parse(ApiEndpoints.fcm);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"token": fcmToken}),
    );
    print("FCM save response: ${response.statusCode}, body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception("Failed to save FCM token");
    }
  }
}
