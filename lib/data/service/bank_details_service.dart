// lib/data/service/bank_details_service.dart
import 'dart:convert';
import '../../core/api_contstant/api_constant.dart';
import 'api_client.dart';

class BankDetailsService {
  Future<Map<String, dynamic>> getBankDetails() async {
    try {
      final url = Uri.parse(ApiEndpoints.bankDetails);
      final response = await ApiClient.get(url);

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
      final url = Uri.parse(ApiEndpoints.bankDetails);
      final response = await ApiClient.post(
        url,
        body: jsonEncode(data),
      );

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
      final url = Uri.parse('${ApiEndpoints.bankDetails}/$id');
      final response = await ApiClient.put(
        url,
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
      final url = Uri.parse('${ApiEndpoints.bankDetails}/$id');
      final response = await ApiClient.delete(url);

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "status": true,
          "message": jsonData["message"] ?? "Bank detail deleted successfully",
        };
      } else {
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
