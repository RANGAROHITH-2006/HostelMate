import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSession extends ChangeNotifier {
  static bool loggedIn = false;

  static final LoginSession _instance = LoginSession._internal();

  factory LoginSession() => _instance;

  LoginSession._internal();

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // Check for hostel_id instead of loggedInHostel to match auth_services
    loggedIn = prefs.containsKey('hostel_id');
    notifyListeners();
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear both hostel_id and hostel_name to match auth_services
    await prefs.remove('hostel_id');
    await prefs.remove('hostel_name');
    loggedIn = false;
    _instance.notifyListeners();
  }

  static Future<String?> getHostelName() async {
    final prefs = await SharedPreferences.getInstance();
    // Get hostel_name instead of loggedInHostel
    return prefs.getString('hostel_name');
  }
}
