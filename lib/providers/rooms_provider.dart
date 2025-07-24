// room_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/rooms_model.dart';
import 'package:hostelmate/services/roomservices.dart';

final roomProvider = StreamProvider.family<List<Room>, String>((ref, floorId) {
  return RoomService().getRoomsStream(floorId);
});

final roomActionsProvider = Provider((ref) => RoomService());
