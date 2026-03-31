import 'dart:convert';
import 'dart:io';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<Map<String, dynamic>> updateProfile(
    String name,
    String email,
    String phone,
    String state,
    String city,
    String address,
    String pincode,
    String district,
    File? imageFile,
    String dob,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return {"status": false, "message": "Token not found, please re-login"};
    }

    final url = Uri.parse(ApiEndpoints.profile);

    var request = http.MultipartRequest(
      'POST',
      url,
    ); // Use POST instead of PATCH

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    // DO NOT set Content-Type manually for MultipartRequest

    // Add text fields
    request.fields.addAll({
      'name': name,
      'email': email,
      'phone': phone,
      'state': state,
      'city': city,
      'address': address,
      'district': district,
      'pincode': pincode,
      'dob': dob,
    });

    // Add profile image if selected
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_pic', imageFile.path),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check if server actually returns JSON
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        return jsonDecode(response.body);
      } else {
        return {"status": false, "message": "Unexpected response from server"};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<ProfileModel> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("token not found re-login");
    }

    final url = Uri.parse(ApiEndpoints.profile);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final responseData = jsonDecode(response.body);

    print("response data $responseData");

    return ProfileModel.fromJson(responseData);
  }
}
