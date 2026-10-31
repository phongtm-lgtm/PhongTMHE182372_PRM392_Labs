class AuthSession {
  const AuthSession(this.name, this.token);
  final String name;
  final String token;
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

abstract class AuthService {
  Future<AuthSession> login(String username, String password);
}

class MockAuthService implements AuthService {
  const MockAuthService();
  @override
  Future<AuthSession> login(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (username == 'student@example.com' && password == 'password123') {
      return const AuthSession('Student', 'mock-demo-token');
    }
    throw const AuthException('Invalid email or password.');
  }
}
