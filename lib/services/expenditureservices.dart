import 'package:hostelmate/models/expenditure_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenditureService {
  final _client = Supabase.instance.client;

  // Get expenditures stream for real-time updates
  Stream<List<Expenditure>> getExpendituresStream(String hostelId) {
    try {
      return _client
          .from('expenditure')
          .stream(primaryKey: ['id'])
          .eq('hostel_id', hostelId)
          .order('created_at', ascending: false)
          .map((data) => data.map((e) => Expenditure.fromMap(e)).toList())
          .handleError((error) {
            print('Expenditure stream error: $error');
            return <Expenditure>[];
          });
    } catch (e) {
      print('Error in expenditure stream: $e');
      // Return empty stream in case of error
      return Stream.value([]);
    }
  }

  // Add fallback method for expenditures
  Future<List<Expenditure>> getExpenditures(String hostelId) async {
    try {
      final response = await _client
          .from('expenditure')
          .select()
          .eq('hostel_id', hostelId)
          .order('created_at', ascending: false);
      return response.map<Expenditure>((e) => Expenditure.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching expenditures: $e');
      return [];
    }
  }

  // Add new expenditure
  Future<void> addExpenditure(String hostelId, String item, double cost) async {
    try {
      await _client.from('expenditure').insert({
        'hostel_id': hostelId,
        'item': item,
        'cost': cost,
      });
      // Add a small delay to ensure the stream updates
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print('Error adding expenditure: $e');
      throw Exception('Failed to add expenditure: $e');
    }
  }

  // Delete expenditure
  Future<void> deleteExpenditure(String expenditureId) async {
    try {
      await _client.from('expenditure').delete().eq('id', expenditureId);
      // Add a small delay to ensure the stream updates
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print('Error deleting expenditure: $e');
      throw Exception('Failed to delete expenditure: $e');
    }
  }

  // Get total expenditure for a hostel
  Future<double> getTotalExpenditure(String hostelId) async {
    try {
      final response = await _client
          .from('expenditure')
          .select('cost')
          .eq('hostel_id', hostelId);
      
      double total = 0;
      for (var item in response) {
        total += (item['cost'] as num).toDouble();
      }
      return total;
    } catch (e) {
      print('Error getting total expenditure: $e');
      return 0;
    }
  }
}
