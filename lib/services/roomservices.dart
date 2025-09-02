import 'package:hostelmate/models/rooms_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService {
  Stream<List<Room>> getRoomsStream(String floorId) {
    return Supabase.instance.client
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('floor_id', floorId,)
        .map((data) => data.map((e) => Room.fromMap(e)).toList())
        .handleError((error) {
          print('Room stream error: $error');
          return <Room>[];
        });
  }

  // Add fallback method
  Future<List<Room>> getRooms(String floorId) async {
    try {
      final response = await Supabase.instance.client
          .from('rooms')
          .select()
          .eq('floor_id', floorId);
      return response.map<Room>((e) => Room.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  Future<void> addRoom(
    String hostelId,
    String floorId,
    String room,
    int capacity,
  ) async {
    await Supabase.instance.client.from('rooms').insert({
      'hostel_id': hostelId,
      'floor_id': floorId,
      'room_number': room,
      'capacity': capacity,
    });
  }

  Future<void> deleteRoom(String roomId) async {
   try {
      await Supabase.instance.client.from('rooms').delete().eq('id', roomId);
    } catch (e) {
      print('Error deleting room: $e');
      throw Exception('Failed to delete room: $e');
    }
  }
}
