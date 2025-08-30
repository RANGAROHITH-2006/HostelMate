// room_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/rooms_model.dart';
import 'package:hostelmate/services/roomservices.dart';

final roomProvider = StreamProvider.family<List<Room>, String>((ref, floorId) {
  return RoomService().getRoomsStream(floorId);
});

final roomServiceProvider = Provider((ref) => RoomService());

final roomActionsProvider = Provider((ref) {
  final service = ref.read(roomServiceProvider);
  return RoomActions(ref, service);
});

class RoomActions {
  final Ref ref;
  final RoomService service;
  RoomActions(this.ref, this.service);

  Future<void> addRoom(String hostelId, String floorId, String roomNumber, int capacity) async {
    await service.addRoom(hostelId, floorId, roomNumber, capacity);
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await service.deleteRoom(roomId);
    } catch (e) {
      print('Error in deleteRoom action: $e');
      rethrow;
    }
  }
}
