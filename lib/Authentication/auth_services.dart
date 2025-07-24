import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> signup(String hostelName, String password) async {
    final existing = await supabase
        .from('hostels')
        .select()
        .eq('hostel_name', hostelName)
        .maybeSingle();

    if (existing != null) return false;

    final hashed = hashPassword(password);
    final result = await supabase.from('hostels').insert({
      'hostel_name': hostelName,
      'password': hashed,
    }).select().single();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hostel_id', result['id']);
    await prefs.setString('hostel_name', result['hostel_name']);
    return true;
  }

  Future<bool> login(String hostelName, String password) async {
    final hostel = await supabase
        .from('hostels')
        .select()
        .eq('hostel_name', hostelName)
        .maybeSingle();

    if (hostel == null) return false;

    final hashed = hashPassword(password);
    if (hostel['password'] == hashed) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('hostel_id', hostel['id']);
      await prefs.setString('hostel_name', hostel['hostel_name']);
      return true;
    }

    return false;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('hostel_id') != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
