import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'api_client.dart';

class FcmTokenService {
  static Future<Map<String, dynamic>> saveFCMToken(String fcmToken) async {
    final url = Uri.parse(ApiEndpoints.fcm);
    var response = await ApiClient.post(
      url,
      body: jsonEncode({"token": fcmToken}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception("Failed to save FCM token");
    }
  }
}
