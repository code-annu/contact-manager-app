import 'package:shared_preferences/shared_preferences.dart';

class UserCredentialUtil{
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';

  /// Save user credentials (email and password) to SharedPreferences.
  Future<void> saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
  }

  /// Get user credentials (email and password) from SharedPreferences.
  Future<Map<String, String?>> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString(_keyEmail);
    final String? password = prefs.getString(_keyPassword);
    return {
      'email': email,
      'password': password,
    };
  }

  /// Clear user credentials from SharedPreferences.
  Future<void> clearCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
  }

}