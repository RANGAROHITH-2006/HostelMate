import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/homescreens/floordetails/roomscard.dart';
import 'package:hostelmate/models/floors_model.dart';
import 'package:hostelmate/popupdialogs/floordialog.dart';
import 'package:hostelmate/providers/floor_provider.dart';
import 'package:hostelmate/providers/rooms_provider.dart';

class FloorCard extends ConsumerWidget {
  final String floorId;
  final Floor floor;
  final String hostelId;
  final VoidCallback onDeleted;
  final VoidCallback onRoomTap;

  const FloorCard({
    super.key,
    required this.floorId,
    required this.floor,
    required this.hostelId,
    required this.onDeleted,
    required this.onRoomTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomProvider(floorId));
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      color: Colors.white,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Floor : ${floor.floorNumber}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    showAddRoomDialog(
                      context: context,
                      onCreate: (roomNumber, capacity) async {
                        final existingRooms =
                            ref.read(roomProvider(floor.id)).valueOrNull;

                        final alreadyExists =
                            existingRooms?.any(
                              (room) => room.roomNumber == roomNumber,
                            ) ??
                            false;
                        if (alreadyExists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Room $roomNumber already exists"),
                            ),
                          );
                          return;
                        }
                        final totalcapacity = int.tryParse(capacity);
                        if (totalcapacity == null || totalcapacity <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter valid capacity"),
                            ),
                          );
                          return;
                        }
                        await ref
                            .read(roomActionsProvider)
                            .addRoom(
                              hostelId,
                              floorId,
                              roomNumber,
                              totalcapacity,
                            );
                        ref.invalidate(roomProvider(floorId));
                      },
                    );
                  },
                  child: const Text("Add Room"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    showDeleteConfirmationDialog(
                      context: context,
                      title: 'Floor',
                      word: 'Rooms',
                      onConfirm: () async {
                        try {
                          await ref
                              .read(floorActionsProvider)
                              .deleteFloor(floor.id, hostelId);
                          ref.invalidate(floorProvider(hostelId));
                          
                          onDeleted();
                        } catch (e) {
                          print('Error deleting floor: $e');
                         
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error deleting floor: $e')),
                          );
                        }
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 233, 95, 85),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Floor',
                        style: TextStyle(
                          color: Color.fromARGB(255, 233, 95, 85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1.5, height: 10),
            const SizedBox(height: 4),
            rooms.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Text("No rooms yet");
                }
                return SizedBox(
                  height: 205,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.6,
                        ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: onRoomTap,
                        child: RoomCard(
                          room: data[index],
                          hostelId: hostelId,
                          onDelete: () async {
                            await showDeleteConfirmationDialog(
                              context: context,
                              title: 'Room',
                              word: 'Students',
                              onConfirm: () async {
                                try {
                                  await ref
                                      .read(roomActionsProvider)
                                      .deleteRoom(data[index].id);
                                  ref.invalidate(roomProvider(floorId));
                                } catch (e) {
                                  print('Error deleting room: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error deleting room: $e')),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
