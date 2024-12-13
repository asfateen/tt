import 'package:shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static final SharedPreferences _prefs = await SharedPreferences.getInstance();

  static Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  static Future<bool> isAuthenticated() async {
    return await getToken() != null;
  }
}