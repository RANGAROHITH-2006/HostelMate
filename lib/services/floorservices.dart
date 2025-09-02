import 'package:supabase_flutter/supabase_flutter.dart';

class FloorService {
  final _client = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getFloorsStream(String hostelId) {
    return _client
        .from('floors')
        .stream(primaryKey: ['id'])
        .eq('hostel_id', hostelId)
        .handleError((error) {
          print('Floor stream error: $error');
          // Return empty list on error to prevent app crash
          return <Map<String, dynamic>>[];
        });
  }

  // Add a method to get floors without stream (fallback)
  Future<List<Map<String, dynamic>>> getFloors(String hostelId) async {
    try {
      final response = await _client
          .from('floors')
          .select()
          .eq('hostel_id', hostelId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching floors: $e');
      return [];
    }
  }

  Future<void> addFloor(String hostelId, int floorNumber) async {
    await _client.from('floors').insert({
      'hostel_id': hostelId,
      'floor_number': floorNumber,
    });
  }

  Future<void> deleteFloor(String floorId) async {
    try {
      await _client.from('floors').delete().eq('id', floorId);
    } catch (e) {
      print('Error deleting floor: $e');
      throw Exception('Failed to delete floor: $e');
    }
  }
}
