import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
    debugPrint("🚀 [ProfileService] updateProfile initiated...");
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      debugPrint("❌ [ProfileService] Token not found in SharedPreferences, aborting.");
      AuthErrorHandler.handleAuthError();
      return {"status": false, "message": "Token not found, please re-login"};
    }

    final url = Uri.parse(ApiEndpoints.profile);
    debugPrint("🌐 [ProfileService] Endpoint URL: $url");

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
    debugPrint("📤 [ProfileService] Form fields payload: $fields");

    if (imageFile != null) {
      debugPrint("🖼️ [ProfileService] Attaching profile image: ${imageFile.path}");
      request.files.add(
        await http.MultipartFile.fromPath('profile_pic', imageFile.path),
      );
    } else {
      debugPrint("🖼️ [ProfileService] No profile image attached.");
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📥 [ProfileService] Response status: ${response.statusCode}");
      debugPrint("📥 [ProfileService] Response body: ${response.body}");

      if (AuthErrorHandler.checkAuthError(response)) {
        debugPrint("⚠️ [ProfileService] Authentication error detected (401).");
        return {"status": false, "message": "Authentication required"};
      }

      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final decoded = jsonDecode(response.body);
        debugPrint("✅ [ProfileService] JSON decoded successfully: $decoded");
        return decoded;
      } else {
        debugPrint("⚠️ [ProfileService] Unexpected response format (non-JSON): ${response.headers['content-type']}");
        return {"status": false, "message": "Unexpected response from server"};
      }
    } catch (e, stack) {
      debugPrint("❌ [ProfileService] updateProfile exception: $e");
      debugPrint("❌ [ProfileService] Stack trace: $stack");
      return {"status": false, "message": e.toString()};
    }
  }

  Future<ProfileModel> fetchProfile() async {
    final url = Uri.parse(ApiEndpoints.profile);
    debugPrint("🚀 [ProfileService] fetchProfile calling GET: $url");

    try {
      var response = await ApiClient.get(url);
      debugPrint("📥 [ProfileService] fetchProfile status: ${response.statusCode}");
      debugPrint("📥 [ProfileService] fetchProfile body: ${response.body}");

      final responseData = jsonDecode(response.body);
      final profileModel = ProfileModel.fromJson(responseData);
      debugPrint("✅ [ProfileService] Profile parsed successfully for user: ${profileModel.data?.name}");
      return profileModel;
    } catch (e, stack) {
      debugPrint("❌ [ProfileService] fetchProfile exception: $e");
      debugPrint("❌ [ProfileService] Stack trace: $stack");
      rethrow;
    }
  }
}
