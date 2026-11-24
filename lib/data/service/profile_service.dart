import 'dart:convert';
import 'dart:io';

import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'package:opinion_easy/data/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'auth_error_handler.dart';

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
    String dob, {
    String? referralCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      AuthErrorHandler.handleAuthError();
      return {"status": false, "message": "Token not found, please re-login"};
    }

    final url = Uri.parse(ApiEndpoints.profile);

    var request = http.MultipartRequest('POST', url);

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    final fields = <String, String>{
      'name': name,
      'email': email,
      'phone': phone,
      'state': state,
      'city': city,
      'address': address,
      'pincode': pincode,
      'dob': dob,
    };

    if (district.isNotEmpty) {
      fields['district'] = district;
    }
    if (referralCode != null && referralCode.trim().isNotEmpty) {
      fields['referral_code'] = referralCode.trim();
    }

    request.fields.addAll(fields);

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_pic', imageFile.path),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (AuthErrorHandler.checkAuthError(response)) {
        return {"status": false, "message": "Authentication required"};
      }

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
    final url = Uri.parse(ApiEndpoints.profile);
    var response = await ApiClient.get(url);
    final responseData = jsonDecode(response.body);
    return ProfileModel.fromJson(responseData);
  }
}
