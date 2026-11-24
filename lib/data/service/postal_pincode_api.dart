import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:opinion_easy/core/api_contstant/api_constant.dart';

class PostalPincodeResult {
  final bool isSuccess;
  final String? state;
  final String? city;
  final String? message;

  PostalPincodeResult({
    required this.isSuccess,
    this.state,
    this.city,
    this.message,
  });
}

class PostalPincodeApi {
  static Future<PostalPincodeResult> verifyPincode(String pincode) async {
    debugPrint("Verify Postal Pincode Calling: $pincode");
    try {
      final uri = Uri.parse("${ApiEndpoints.postalPincode}$pincode");
      final response = await http.get(uri);

      debugPrint("Verify Postal Pincode StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          final first = decoded[0];
          final status = first["Status"]?.toString();

          if (status?.toLowerCase() == "success") {
            final postOffices = first["PostOffice"] as List<dynamic>?;
            if (postOffices != null && postOffices.isNotEmpty) {
              final po = postOffices[0];
              final state = po["State"]?.toString() ?? "";
              // Division matches user's reference (e.g. Channapatna for 562114)
              final city = po["Division"]?.toString() ??
                  po["District"]?.toString() ??
                  po["Circle"]?.toString() ??
                  "";

              return PostalPincodeResult(
                isSuccess: true,
                state: state,
                city: city,
                message: first["Message"]?.toString(),
              );
            }
          }
        }
      }

      return PostalPincodeResult(
        isSuccess: false,
        message: "Invalid Pincode ..!",
      );
    } catch (e) {
      debugPrint("Verify Postal Pincode Error: $e");
      return PostalPincodeResult(
        isSuccess: false,
        message: "Invalid Pincode ..!",
      );
    }
  }
}
