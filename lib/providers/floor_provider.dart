import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/floors_model.dart';
import 'package:hostelmate/services/floorservices.dart'; 

final floorServiceProvider = Provider((ref) => FloorService());

// Add a fallback provider that uses Future instead of Stream
final floorDataProvider = FutureProvider.family<List<Floor>, String>((ref, hostelId) async {
  final service = ref.watch(floorServiceProvider);
  try {
    final data = await service.getFloors(hostelId);
    return data.map((e) => Floor.fromMap(e)).toList();
  } catch (e) {
    print('Error in floorDataProvider: $e');
    return <Floor>[];
  }
});

final floorProvider = StreamProvider.family<List<Floor>, String>((ref, hostelId) {
  final service = ref.watch(floorServiceProvider);
  return service.getFloorsStream(hostelId).map(
        (data) => data.map((e) => Floor.fromMap(e)).toList(),
      ).handleError((error) {
        print('Floor provider stream error: $error');
        // Fallback to the future provider data
        ref.read(floorDataProvider(hostelId));
      });
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
    // Refresh both providers
    ref.invalidate(floorProvider(hostelId));
    ref.invalidate(floorDataProvider(hostelId));
  }

  Future<void> deleteFloor(String floorId, String hostelId) async {
    try {
      await service.deleteFloor(floorId);
      ref.invalidate(floorProvider(hostelId));
      ref.invalidate(floorDataProvider(hostelId));
      // Force refresh the data
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      print('Error in deleteFloor action: $e');
      rethrow;
    }
  }
}
