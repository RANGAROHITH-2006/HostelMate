import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/homescreens/floordetails/floorcard.dart';
import 'package:hostelmate/popupdialogs/floordialog.dart';
import 'package:hostelmate/providers/floor_provider.dart';
import 'package:hostelmate/models/rooms_model.dart';

class FloorsAndRoomsPage extends ConsumerStatefulWidget {
  final String hostelId;
  final Function(Room room, String floorName) onRoomTap;

  const FloorsAndRoomsPage({
    super.key,
    required this.hostelId,
    required this.onRoomTap,
  });

  @override
  ConsumerState<FloorsAndRoomsPage> createState() => _FloorsAndRoomsPageState();
}

class _FloorsAndRoomsPageState extends ConsumerState<FloorsAndRoomsPage> {
  int? selectedFloorNumber;

  @override
  Widget build(BuildContext context) {
    final floorsAsync = ref.watch(floorProvider(widget.hostelId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade500, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Floors & Rooms",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          floorsAsync.when(
            data: (floors) {
              if (floors.isEmpty) {
                return const Center(child: Text("No floors added yet"));
              }
              final floorNumbers =
                  floors.map((f) => f.floorNumber).toSet().toList()..sort();
              
              // Reset selectedFloorNumber if it doesn't exist in current floors
              if (selectedFloorNumber != null && !floorNumbers.contains(selectedFloorNumber)) {
                selectedFloorNumber = floorNumbers.isNotEmpty ? floorNumbers.first : null;
              }
              
              selectedFloorNumber ??= floorNumbers.isNotEmpty ? floorNumbers.first : null;

              // If no floors exist, show a message
              if (floorNumbers.isEmpty || selectedFloorNumber == null) {
                return const Center(child: Text("No floors available"));
              }

              final selectedFloor = floors.firstWhere(
                (f) => f.floorNumber == selectedFloorNumber,
                orElse: () => floors.first,
              );
              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              border: Border.all(
                                color: Colors.grey.shade500,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: floorNumbers.contains(selectedFloorNumber) ? selectedFloorNumber : null,
                                onChanged: (val) {
                                  setState(() {
                                    selectedFloorNumber = val!;
                                  });
                                },
                                items:
                                    floorNumbers
                                        .map(
                                          (num) => DropdownMenuItem(
                                            value: num,
                                            child: Text(
                                              "Floor  $num",
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                underline: Container(),
                                style: const TextStyle(color: Colors.black),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              showAddFloorDialog(
                                context: context,
                                onCreate: (name) async {
                                  final floorNumber = int.tryParse(name);
                                  final existingFloors =
                                      ref
                                          .read(floorProvider(widget.hostelId))
                                          .valueOrNull;
                                  if (floorNumber == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please enter a valid number for floor",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  final alreadyExists =
                                      existingFloors?.any(
                                        (f) => f.floorNumber == floorNumber,
                                      ) ??
                                      false;

                                  if (alreadyExists) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Floor $floorNumber already exists",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  await ref
                                      .read(floorActionsProvider)
                                      .addFloor(widget.hostelId, floorNumber);
                                  ref.invalidate(
                                    floorProvider(widget.hostelId),
                                  );
                                  Future.microtask(
                                    () => Navigator.pop(context),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: Text(
                              "Floor",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FloorCard(
                      floorId: selectedFloor.id,
                      floor: selectedFloor,
                      hostelId: widget.hostelId,
                      onDeleted: () {
                        setState(() {
                          
                        });
                      },
                      onRoomTap: widget.onRoomTap,
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
          ),
        ],
      ),
    );
  }
}
