import 'package:hostelmate/models/rooms_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService {
  Stream<List<Room>> getRoomsStream(String floorId) {
    return Supabase.instance.client
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('floor_id', floorId,)
        .map((data) => data.map((e) => Room.fromMap(e)).toList());
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
    await Supabase.instance.client.from('rooms').delete().eq('id', roomId);
  }


  
}
