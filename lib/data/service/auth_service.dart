import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> register(
    Map<String, dynamic> requestData,
  ) async {
    final url = Uri.parse(ApiEndpoints.signUp);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(requestData),
    );

    final responeBody = jsonDecode(response.body);

    print("res of reg $responeBody");

    return responeBody;
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> requestData) async {
    final url = Uri.parse(ApiEndpoints.login);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(requestData),
    );
    print("response ${response.body}");
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> fotgotMpin(
    Map<String, dynamic> requestData,
  ) async {
    final url = Uri.parse(ApiEndpoints.forgotMPIN);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode(requestData),
    );
    print("res of forgot ${response.body}");

    return jsonDecode(response.body);
  }
}
