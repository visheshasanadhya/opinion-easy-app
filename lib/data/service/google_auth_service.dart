import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:opinion_easy/core/api_contstant/api_constant.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: !kIsWeb && Platform.isIOS
        ? '102808375831-c7p91d4e58rkgsq8ipcp33203bfcjffj.apps.googleusercontent.com'
        : null,
    serverClientId:
        '102808375831-b7ve29jo39satgklqmon7cdrt4f8euo8.apps.googleusercontent.com',
  );

  /// Step 1: Flutter triggers Google Sign-In popup → gets account
  static Future<Map<String, String>?> getGoogleTokens() async {
    try {
      await _googleSignIn.signOut(); // Always show account picker
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // User cancelled

      final auth = await account.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null) return null;

      return {
        'id_token': idToken,
        'access_token': accessToken ?? '',
        'email': account.email,
        'name': account.displayName ?? '',
        'photo': account.photoUrl ?? '',
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Step 2: Flutter → Laravel: Send idToken to backend
  static Future<Map<String, dynamic>> sendTokenToBackend(
    String idToken,
    String accessToken,
  ) async {
    final url = Uri.parse(ApiEndpoints.googleLogin);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        'id_token': idToken,
        'access_token': accessToken,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
