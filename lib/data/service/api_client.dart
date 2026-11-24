import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_error_handler.dart';

class ApiClient {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> getHeaders({
    Map<String, String>? extraHeaders,
  }) async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      if (extraHeaders != null) ...extraHeaders,
    };
  }

  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final finalHeaders = await getHeaders(extraHeaders: headers);
    final response = await http.get(url, headers: finalHeaders);
    if (AuthErrorHandler.checkAuthError(response)) {
      throw AuthException(response.body);
    }
    return response;
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final finalHeaders = await getHeaders(extraHeaders: headers);
    final response = await http.post(url, headers: finalHeaders, body: body);
    if (AuthErrorHandler.checkAuthError(response)) {
      throw AuthException(response.body);
    }
    return response;
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final finalHeaders = await getHeaders(extraHeaders: headers);
    final response = await http.put(url, headers: finalHeaders, body: body);
    if (AuthErrorHandler.checkAuthError(response)) {
      throw AuthException(response.body);
    }
    return response;
  }

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final finalHeaders = await getHeaders(extraHeaders: headers);
    final response = await http.delete(url, headers: finalHeaders);
    if (AuthErrorHandler.checkAuthError(response)) {
      throw AuthException(response.body);
    }
    return response;
  }
}
