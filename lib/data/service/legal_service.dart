import 'dart:convert';
import 'package:opinion_easy/core/api_contstant/api_constant.dart';
import 'api_client.dart';

class LegalService {
  Future<Map<String, dynamic>> fetchTerms() async {
    final url = Uri.parse(ApiEndpoints.terms);
    final response = await ApiClient.getPublic(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['data'] as Map<String, dynamic>?) ?? {};
    }
    throw Exception('Failed to load terms');
  }

  Future<Map<String, dynamic>> fetchPrivacy() async {
    final url = Uri.parse(ApiEndpoints.privacy);
    final response = await ApiClient.getPublic(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['data'] as Map<String, dynamic>?) ?? {};
    }
    throw Exception('Failed to load privacy policy');
  }

  Future<Map<String, dynamic>> fetchAboutUs() async {
    final url = Uri.parse(ApiEndpoints.aboutUs);
    final response = await ApiClient.getPublic(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['data'] as Map<String, dynamic>?) ?? {};
    }
    throw Exception('Failed to load about us');
  }

  Future<Map<String, dynamic>> fetchHelpSupport() async {
    final url = Uri.parse(ApiEndpoints.helpSupport);
    final response = await ApiClient.getPublic(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['data'] as Map<String, dynamic>?) ?? {};
    }
    throw Exception('Failed to load help & support');
  }
}
