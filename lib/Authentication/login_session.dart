import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSession extends ChangeNotifier {
  static bool loggedIn = false;

  static final LoginSession _instance = LoginSession._internal();

  factory LoginSession() => _instance;

  LoginSession._internal();

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.containsKey('loggedInHostel');
    notifyListeners();
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInHostel');
    loggedIn = false;
    _instance.notifyListeners();
  }

  static Future<String?> getHostelName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInHostel');
  }
}
