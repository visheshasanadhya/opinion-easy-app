import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_error_handler.dart';
import 'internet_monitor.dart';

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
    bool checkAuth = true,
  }) async {
    if (InternetMonitor.isOffline) {
      debugPrint("⚠️ [ApiClient] Suppressed GET $url (Device is offline)");
      throw const SocketException("Network is unreachable");
    }
    try {
      final finalHeaders = await getHeaders(extraHeaders: headers);
      final response = await http.get(url, headers: finalHeaders);
      if (checkAuth && AuthErrorHandler.checkAuthError(response)) {
        throw AuthException(response.body);
      }
      return response;
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) {
        InternetMonitor.showOfflineDialog();
      }
      rethrow;
    }
  }

  /// Public GET request: does NOT send or require an auth token,
  /// and does NOT trigger authentication redirect on 401.
  static Future<http.Response> getPublic(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    if (InternetMonitor.isOffline) {
      debugPrint("⚠️ [ApiClient] Suppressed GET (public) $url (Device is offline)");
      throw const SocketException("Network is unreachable");
    }
    try {
      final publicHeaders = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (headers != null) ...headers,
      };
      return await http.get(url, headers: publicHeaders);
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) {
        InternetMonitor.showOfflineDialog();
      }
      rethrow;
    }
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    if (InternetMonitor.isOffline) {
      debugPrint("⚠️ [ApiClient] Suppressed POST $url (Device is offline)");
      throw const SocketException("Network is unreachable");
    }
    try {
      final finalHeaders = await getHeaders(extraHeaders: headers);
      final response = await http.post(url, headers: finalHeaders, body: body);
      if (AuthErrorHandler.checkAuthError(response)) {
        throw AuthException(response.body);
      }
      return response;
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) {
        InternetMonitor.showOfflineDialog();
      }
      rethrow;
    }
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    if (InternetMonitor.isOffline) {
      debugPrint("⚠️ [ApiClient] Suppressed PUT $url (Device is offline)");
      throw const SocketException("Network is unreachable");
    }
    try {
      final finalHeaders = await getHeaders(extraHeaders: headers);
      final response = await http.put(url, headers: finalHeaders, body: body);
      if (AuthErrorHandler.checkAuthError(response)) {
        throw AuthException(response.body);
      }
      return response;
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) {
        InternetMonitor.showOfflineDialog();
      }
      rethrow;
    }
  }

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    if (InternetMonitor.isOffline) {
      debugPrint("⚠️ [ApiClient] Suppressed DELETE $url (Device is offline)");
      throw const SocketException("Network is unreachable");
    }
    try {
      final finalHeaders = await getHeaders(extraHeaders: headers);
      final response = await http.delete(url, headers: finalHeaders);
      if (AuthErrorHandler.checkAuthError(response)) {
        throw AuthException(response.body);
      }
      return response;
    } catch (e) {
      if (InternetMonitor.isNetworkError(e)) {
        InternetMonitor.showOfflineDialog();
      }
      rethrow;
    }
  }
}
