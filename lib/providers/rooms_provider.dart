// room_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/rooms_model.dart';
import 'package:hostelmate/services/roomservices.dart';

final roomServiceProvider = Provider((ref) => RoomService());

// Add fallback provider
final roomDataProvider = FutureProvider.family<List<Room>, String>((ref, floorId) async {
  final service = ref.watch(roomServiceProvider);
  try {
    return await service.getRooms(floorId);
  } catch (e) {
    print('Error in roomDataProvider: $e');
    return <Room>[];
  }
});

final roomProvider = StreamProvider.family<List<Room>, String>((ref, floorId) {
  final service = ref.watch(roomServiceProvider);
  return service.getRoomsStream(floorId).handleError((error) {
    print('Room provider stream error: $error');
    // Fallback to the future provider data
    ref.read(roomDataProvider(floorId));
  });
});

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
    // Refresh both providers
    ref.invalidate(roomProvider(floorId));
    ref.invalidate(roomDataProvider(floorId));
  }

  Future<void> deleteRoom(String roomId, String floorId) async {
    try {
      await service.deleteRoom(roomId);
      ref.invalidate(roomProvider(floorId));
      ref.invalidate(roomDataProvider(floorId));
    } catch (e) {
      print('Error in deleteRoom action: $e');
      rethrow;
    }
  }
}
