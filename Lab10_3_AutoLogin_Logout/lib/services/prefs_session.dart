import 'package:shared_preferences/shared_preferences.dart';

import '../simple_app.dart';
import 'auth_service.dart';

class PrefsSession implements SessionStore {
  static const tokenKey = 'lab10.api.token';
  static const nameKey = 'lab10.api.name';

  @override
  Future<AuthSession?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    if (token == null || token.isEmpty) return null;
    return AuthSession(prefs.getString(nameKey) ?? 'User', token);
  }

  @override
  Future<void> save(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, session.token);
    await prefs.setString(nameKey, session.name);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(nameKey);
  }
}
