import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';

class RoomDetailsScreen extends ConsumerWidget {
  final String roomId;
  final String floorName;
  final VoidCallback onBack;

  const RoomDetailsScreen({
    super.key,
    required this.roomId,
    required this.floorName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStudents = ref.watch(allStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Room $roomId'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: allStudents.when(
          data: (students) {
            final roomStudents = students.where((s) => s.roomId == roomId).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Info
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text('${roomStudents.length}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.bed),
                    const SizedBox(width: 8),
                    const Text('5'), 
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: roomStudents.length / 5),
                const SizedBox(height: 4),
                Text("${roomStudents.length} of 5 beds occupied (${(roomStudents.length / 5 * 100).toInt()}%)"),

                const SizedBox(height: 20),
                const Text(
                  "Current Students",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: GridView.builder(
                    itemCount: roomStudents.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      childAspectRatio: 5,
                    ),
                    itemBuilder: (context, index) {
                      final student = roomStudents[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(student.name[0]),
                          ),
                          title: Text(student.name.toUpperCase()),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.phone, size: 16),
                              const SizedBox(width: 4),
                              Text(student.phone),
                              const SizedBox(width: 12),
                              const Icon(Icons.email, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  student.email,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add student logic
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text("Add Student"),
                  ),
                )
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
