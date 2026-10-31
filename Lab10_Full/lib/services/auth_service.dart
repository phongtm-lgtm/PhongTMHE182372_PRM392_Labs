import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthSession {
  const AuthSession(this.name, this.token);
  final String name;
  final String token;
}

abstract class AuthService {
  Future<AuthSession> login(String user, String password);
}

class MockAuthService implements AuthService {
  @override
  Future<AuthSession> login(String user, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (user == 'student@example.com' && password == 'password123') {
      return const AuthSession('Student', 'mock-demo-token');
    }
    throw const AuthException('Invalid email or password.');
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiAuthService implements AuthService {
  ApiAuthService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  @override
  Future<AuthSession> login(String user, String password) async {
    try {
      final response = await _client
          .post(
            Uri.parse('https://dummyjson.com/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': user,
              'password': password,
              'expiresInMins': 30,
            }),
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        throw const AuthException('Login failed. Check your credentials.');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['accessToken'] as String? ?? data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw const AuthException('Server did not return a token.');
      }
      return AuthSession(data['username'] as String? ?? user, token);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(
        'Network error. Check your connection and try again.',
      );
    }
  }
}
