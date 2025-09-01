import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final studentProvider = StateNotifierProvider<StudentNotifier, List<Map<String, dynamic>>>(
  (ref) => StudentNotifier(),
);

// Provider to trigger refresh of allStudentsProvider
final studentRefreshProvider = StateProvider<int>((ref) => 0);

class StudentNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  StudentNotifier() : super([]);

  Future<void> addStudent({
    required String hostelId,
    required String roomId,
    required String fullName,
    required String phoneNumber,
    String? email,
    required String checkInDate,
    required double roomRent,
    required String aadharNumber,
    required String parentPhoneNumber,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('students').insert({
        'hostel_id': hostelId,
        'room_id': roomId,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'check_in_date': checkInDate,
        'room_rent': roomRent,
        'aadhar_number': aadharNumber,
        'parent_phone_number': parentPhoneNumber,
      }).select();

      if (response.isEmpty) {
        throw Exception('Failed to add student. No data returned.');
      }

      state = [...state, ...response];
    } catch (e) {
      print('Error adding student: $e');
      rethrow; // Re-throw so the UI can handle the error
    }
  }

  Future<void> removeStudent(String studentId) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('students').delete().eq('id', studentId);
      
      // Remove from local state as well
      state = state.where((student) => student['id'] != studentId).toList();
    } catch (e) {
      print('Error removing student: $e');
      rethrow;
    }
  }

  Future<void> updateStudent({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    String? email,
    required String checkInDate,
    required double roomRent,
    required String aadharNumber,
    required String parentPhoneNumber,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('students').update({
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'check_in_date': checkInDate,
        'room_rent': roomRent,
        'aadhar_number': aadharNumber,
        'parent_phone_number': parentPhoneNumber,
      }).eq('id', studentId).select();

      if (response.isEmpty) {
        throw Exception('Failed to update student. No data returned.');
      }

      // Update local state
      state = state.map((student) {
        if (student['id'] == studentId) {
          return response.first;
        }
        return student;
      }).toList();
    } catch (e) {
      print('Error updating student: $e');
      rethrow;
    }
  }
}
