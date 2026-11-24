import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/api_contstant/api_constant.dart';
import '../model/razorpay_ifsc_model.dart';

class RazorpayIfscApi {
  static Future<RazorpayIfscModel?> callApi(String ifscCode) async {
    final cleanIfsc = ifscCode.trim().toUpperCase();
    debugPrint("Razorpay IFSC Api Calling for IFSC => $cleanIfsc");
    try {
      final uri = Uri.parse("${ApiEndpoints.razorpayIfsc}$cleanIfsc");
      debugPrint("Razorpay IFSC Api Uri => $uri");

      final response = await http.get(uri);

      // debugPrint("Razorpay IFSC Api StatusCode => ${response.statusCode}");
      // debugPrint("Razorpay IFSC Api Response   => ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return RazorpayIfscModel.fromJson(decoded);
        }
      }
      return null;
    } catch (e) {
      debugPrint("Razorpay IFSC Api Exception => $e");
      return null;
    }
  }
}
