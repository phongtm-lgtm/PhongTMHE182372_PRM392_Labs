import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiAuthService implements AuthService {
  ApiAuthService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  @override
  Future<AuthSession> login(String username, String password) async {
    try {
      final response = await _client
          .post(
            Uri.parse('https://dummyjson.com/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'expiresInMins': 30,
            }),
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        throw const AuthException('Login failed. Check your credentials.');
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final token = body['accessToken'] as String? ?? body['token'] as String?;
      if (token == null || token.isEmpty) {
        throw const AuthException('Server did not return a token.');
      }
      return AuthSession(body['username'] as String? ?? username, token);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Network error. Check your connection.');
    }
  }
}

