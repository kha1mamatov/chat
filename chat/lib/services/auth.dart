import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static const String _userIdKey = 'user_id';

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return int.parse(prefs.getString(_userIdKey)!);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userIdKey);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
