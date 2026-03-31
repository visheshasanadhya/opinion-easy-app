// lib/data/service/bank_details_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_contstant/api_constant.dart';

class BankDetailsService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getBankDetails() async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('${ApiEndpoints.baseUrl}/customer-bank-details');

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return {
          "status": true,
          "data": jsonData["data"] ?? [],
          "message": "Bank details fetched successfully",
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "status": false,
          "message": errorData["message"] ?? "Failed to fetch bank details",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addBankDetail(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('${ApiEndpoints.baseUrl}/customer-bank-details');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      print("Response Body: ${response.body}");

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": true,
          "data": jsonData["data"],
          "message": jsonData["message"] ?? "Bank detail added successfully",
        };
      } else {
        return {
          "status": false,
          "message": jsonData["message"] ?? "Failed to add bank detail",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateBankDetail(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse(
        '${ApiEndpoints.baseUrl}/customer-bank-details/$id',
      );

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "status": true,
          "data": jsonData["data"],
          "message": jsonData["message"] ?? "Bank detail updated successfully",
        };
      } else {
        return {
          "status": false,
          "message": jsonData["message"] ?? "Failed to update bank detail",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteBankDetail(String id) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse(
        '${ApiEndpoints.baseUrl}/customer-bank-details/$id',
      );

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        final jsonData = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {"message": "Bank detail deleted successfully"};
        return {
          "status": true,
          "message": jsonData["message"] ?? "Bank detail deleted successfully",
        };
      } else {
        final jsonData = jsonDecode(response.body);
        return {
          "status": false,
          "message": jsonData["message"] ?? "Failed to delete bank detail",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
