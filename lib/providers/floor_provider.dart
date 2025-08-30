import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/floors_model.dart';
import 'package:hostelmate/services/floorservices.dart'; 


final floorServiceProvider = Provider((ref) => FloorService());


final floorProvider = StreamProvider.family<List<Floor>, String>((ref, hostelId) {
  final service = ref.watch(floorServiceProvider);
  return service.getFloorsStream(hostelId).map(
        (data) => data.map((e) => Floor.fromMap(e)).toList(),
      );
});

final floorActionsProvider = Provider((ref) {
  final service = ref.read(floorServiceProvider);
  return FloorActions(ref, service);
});

class FloorActions {
  final Ref ref;
  final FloorService service;
  FloorActions(this.ref, this.service);

  Future<void> addFloor(String hostelId, int floorNumber) async {
    await service.addFloor(hostelId, floorNumber);
    
  }

  Future<void> deleteFloor(String floorId, String hostelId) async {
    try {
      await service.deleteFloor(floorId);
      ref.invalidate(floorProvider(hostelId));
      // Force refresh the data
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print('Error in deleteFloor action: $e');
      rethrow;
    }
  }
}
