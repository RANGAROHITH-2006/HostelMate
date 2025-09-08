import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';
import 'package:hostelmate/providers/hostel_provider.dart';
import 'package:hostelmate/providers/payment_provider.dart';
import 'package:hostelmate/models/roomdatamodel.dart';

class Unpaidstatus extends ConsumerWidget {
  const Unpaidstatus({super.key});
  // New redesigned unpaid students page

  Future<void> _showPaymentConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    StudentModel student,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark as Paid'),
          content: Text('Mark payment as received for ${student.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _updatePaymentStatus(context, ref, student);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePaymentStatus(
    BuildContext context,
    WidgetRef ref,
    StudentModel student,
  ) async {
    try {
      final paymentAction = ref.read(paymentActionProvider);
      final success = await paymentAction.markStudentPaid(student.id);

      if (success) {
        ref.invalidate(allStudentsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${student.name} marked as paid'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update payment status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStudentsAsync = ref.watch(allStudentsProvider);
    final allRoomsAsync = ref.watch(allRoomsProvider);
    final hostelIdAsync = ref.watch(hostelIdProvider);

    return Scaffold(
       backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Unpaid Students'),
        backgroundColor: const Color(0xFF0B1E38),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove back button for tab navigation
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

                  // Filter unpaid students
                  final unpaidStudents = hostelStudents
                      .where((student) => !student.isPaid)
                      .toList();

                  // Calculate total unpaid amount
                  final totalUnpaidAmount = unpaidStudents.fold<double>(
                    0.0, 
                    (sum, student) => sum + student.roomRent,
                  );

                  return UnpaidStudentsView(
                    allStudents: hostelStudents,
                    unpaidStudents: unpaidStudents,
                    totalUnpaidAmount: totalUnpaidAmount,
                    roomsMap: roomsMap,
                    onPaymentUpdate: (student) async {
                      await _showPaymentConfirmationDialog(context, ref, student);
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

class UnpaidStudentsView extends StatefulWidget {
  final List<StudentModel> allStudents;
  final List<StudentModel> unpaidStudents;
  final double totalUnpaidAmount;
  final Map<String, Map<String, dynamic>> roomsMap;
  final Function(StudentModel) onPaymentUpdate;

  const UnpaidStudentsView({
    super.key,
    required this.allStudents,
    required this.unpaidStudents,
    required this.totalUnpaidAmount,
    required this.roomsMap,
    required this.onPaymentUpdate,
  });

  @override
  State<UnpaidStudentsView> createState() => _UnpaidStudentsViewState();
}

class _UnpaidStudentsViewState extends State<UnpaidStudentsView> {
  String searchQuery = '';
  List<StudentModel> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = widget.unpaidStudents;
  }

  @override
  void didUpdateWidget(UnpaidStudentsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unpaidStudents != widget.unpaidStudents) {
      _filterStudents();
    }
  }

  void _filterStudents() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredStudents = widget.unpaidStudents;
      } else {
        filteredStudents = widget.unpaidStudents.where((student) {
          final name = student.name.toLowerCase();
          final phone = student.phone.toLowerCase();
          final roomNumber = _getRoomNumber(student.roomId).toLowerCase();
          final query = searchQuery.toLowerCase();
          
          return name.contains(query) || 
                 phone.contains(query) || 
                 roomNumber.contains(query);
        }).toList();
      }
    });
  }

  String _getRoomNumber(String roomId) {
    final roomData = widget.roomsMap[roomId];
    return roomData?['room_number']?.toString() ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.unpaidStudents.isEmpty) {
      return Center(
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

    // Group filtered students by room
    final Map<String, List<StudentModel>> studentsByRoom = {};
    for (final student in filteredStudents) {
      final roomNumber = _getRoomNumber(student.roomId);
      
      if (!studentsByRoom.containsKey(roomNumber)) {
        studentsByRoom[roomNumber] = [];
      }
      studentsByRoom[roomNumber]!.add(student);
    }

    return Column(
      children: [
        // Overview Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B1E38), Color(0xFF1A3A5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.money_off,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Unpaid Students Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Complete unpaid students information',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.group,
                      widget.allStudents.length.toString(),
                      'Total Students',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      Icons.money_off,
                      widget.unpaidStudents.length.toString(),
                      'Unpaid Students',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      Icons.currency_rupee,
                      '₹${widget.totalUnpaidAmount.toStringAsFixed(0)}',
                      'Total Unpaid',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade600),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    searchQuery = value;
                    _filterStudents();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, room number...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Students List
        Expanded(
          child: filteredStudents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No students found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: studentsByRoom.keys.length,
                  itemBuilder: (context, index) {
                    final roomNumber = studentsByRoom.keys.elementAt(index);
                    final roomStudents = studentsByRoom[roomNumber]!;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.meeting_room,
                                   color: Color(0xFF0B1E38),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Room $roomNumber',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                     color: Color(0xFF0B1E38),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${roomStudents.length} student${roomStudents.length > 1 ? 's' : ''}',
                                  style: const TextStyle(
                                     color: Color(0xFF0B1E38),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...roomStudents.map((student) => ListTile(
                            onTap: () {
                              // Navigate to student details page
                              final roomNumber = _getRoomNumber(student.roomId);
                              
                              context.push('/student_details', extra: {
                                'student': student,
                                'roomNumber': roomNumber,
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF0B1E38),
                              child: Text(
                                student.name.isNotEmpty 
                                    ? student.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
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
                            subtitle: Text('📞 ${student.phone}'),
                            trailing: GestureDetector(
                              onTap: () => widget.onPaymentUpdate(student),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'UNPAID',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          )).toList(),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
