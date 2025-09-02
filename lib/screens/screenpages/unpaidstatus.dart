import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';
import 'package:hostelmate/providers/hostel_provider.dart';
import 'package:hostelmate/models/roomdatamodel.dart';

class Student {
  final String name;
  final String roomNumber;
  final double feeAmount;
  final bool isUnpaid;

  Student({
    required this.name,
    required this.roomNumber,
    required this.feeAmount,
    required this.isUnpaid,
  });
}

class Unpaidstatus extends ConsumerWidget {
  const Unpaidstatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStudentsAsync = ref.watch(allStudentsProvider);
    final allRoomsAsync = ref.watch(allRoomsProvider);
    final hostelIdAsync = ref.watch(hostelIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unpaid Students'),
        backgroundColor: const Color(0xFF0B1E38),
        foregroundColor: Colors.white,
      ),
      body: hostelIdAsync.when(
        data: (hostelId) {
          if (hostelId == null) {
            return const Center(
              child: Text('No hostel data available'),
            );
          }

          return allStudentsAsync.when(
            data: (allStudents) {
              return allRoomsAsync.when(
                data: (roomsMap) {
                  // Filter students by hostel ID
                  final hostelStudents = allStudents
                      .where((student) => student.hostelId == hostelId)
                      .toList();

                  print('Total students in hostel: ${hostelStudents.length}');
                  for (final student in hostelStudents) {
                    print('Student: ${student.name}, Room: ${student.roomId}, Paid: ${student.isPaid}');
                  }

                  // Filter unpaid students based on is_paid field
                  final unpaidStudents = hostelStudents
                      .where((student) => !student.isPaid)
                      .toList();

                  print('Unpaid students count: ${unpaidStudents.length}');

                  if (unpaidStudents.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'All students have paid their fees!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Group students by room
                  final Map<String, List<StudentModel>> studentsByRoom = {};
                  for (final student in unpaidStudents) {
                    final roomData = roomsMap[student.roomId];
                    final roomNumber = roomData?['room_number']?.toString() ?? 'Unknown';
                    
                    if (!studentsByRoom.containsKey(roomNumber)) {
                      studentsByRoom[roomNumber] = [];
                    }
                    studentsByRoom[roomNumber]!.add(student);
                  }

                  // Sort room numbers
                  final sortedRoomNumbers = studentsByRoom.keys.toList()
                    ..sort((a, b) {
                      // Handle numeric sorting
                      final aInt = int.tryParse(a);
                      final bInt = int.tryParse(b);
                      if (aInt != null && bInt != null) {
                        return aInt.compareTo(bInt);
                      }
                      return a.compareTo(b);
                    });

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedRoomNumbers.length,
                    itemBuilder: (context, index) {
                      final roomNumber = sortedRoomNumbers[index];
                      final roomStudents = studentsByRoom[roomNumber]!;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.meeting_room,
                                    color: Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Room $roomNumber',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${roomStudents.length} unpaid',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...roomStudents.map((student) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red.shade200,
                                child: Text(
                                  student.name.isNotEmpty 
                                      ? student.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                student.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone: ${student.phone}'),
                                  Text('Fee: ₹${student.roomRent.toStringAsFixed(2)}'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'UNPAID',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )).toList(),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading rooms: $error'),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading students: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading hostel data: $error'),
        ),
      ),
    );
  }
}