import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Update payment status for a student
  Future<bool> updatePaymentStatus(String studentId, bool isPaid) async {
    try {
      final response = await _supabase
          .from('students')
          .update({'is_paid': isPaid})
          .eq('id', studentId)
          .select();

      return response.isNotEmpty;
    } catch (e) {
      print('Error updating payment status: $e');
      return false;
    }
  }

  /// Get payment status for a specific student
  Future<bool?> getPaymentStatus(String studentId) async {
    try {
      final response = await _supabase
          .from('students')
          .select('is_paid')
          .eq('id', studentId)
          .single();

      return response['is_paid'] as bool?;
    } catch (e) {
      print('Error getting payment status: $e');
      return null;
    }
  }

  /// Mark multiple students as paid
  Future<bool> markMultipleStudentsPaid(List<String> studentIds) async {
    try {
      final response = await _supabase
          .from('students')
          .update({'is_paid': true})
          .inFilter('id', studentIds)
          .select();

      return response.length == studentIds.length;
    } catch (e) {
      print('Error updating multiple payment statuses: $e');
      return false;
    }
  }
}
