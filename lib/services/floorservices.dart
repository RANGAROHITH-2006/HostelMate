import 'package:supabase_flutter/supabase_flutter.dart';

class FloorService {
  final _client = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getFloorsStream(String hostelId) {
    return _client
        .from('floors')
        .stream(primaryKey: ['id'])
        .eq('hostel_id', hostelId);
  }

  Future<void> addFloor(String hostelId, int floorNumber) async {
    await _client.from('floors').insert({
      'hostel_id': hostelId,
      'floor_number': floorNumber,
    });
  }

  Future<void> deleteFloor(String floorId) async {
    await _client.from('floors').delete().eq('id', floorId,);
  }
}
