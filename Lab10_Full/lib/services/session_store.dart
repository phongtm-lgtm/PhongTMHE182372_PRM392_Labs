import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  static const _tokenKey = 'lab10.api.token';
  static const _nameKey = 'lab10.api.name';

  Future<(String, String)?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    return (preferences.getString(_nameKey) ?? 'User', token);
  }

  Future<void> save(String name, String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
    await preferences.setString(_nameKey, name);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_nameKey);
  }
}
