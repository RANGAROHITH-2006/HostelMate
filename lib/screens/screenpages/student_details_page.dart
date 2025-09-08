import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostelmate/models/roomdatamodel.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';
import 'package:hostelmate/providers/student_provider.dart';
import 'package:hostelmate/utils/phone_utils.dart';

class StudentDetailsPage extends ConsumerWidget {
  final StudentModel student;
  final String roomNumber;

  const StudentDetailsPage({
    super.key,
    required this.student,
    required this.roomNumber,
  });

  Future<void> _editStudent(BuildContext context) async {
    context.push('/add_student?hostelId=${student.hostelId}&roomId=${student.roomId}&isEditing=true', 
      extra: student);
  }

  Future<void> _removeStudent(BuildContext context, WidgetRef ref) async {
    bool? shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Student'),
        content: Text('Are you sure you want to remove ${student.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      try {
        // Remove student logic here
        await ref.read(studentProvider.notifier).removeStudent(student.id);
        ref.invalidate(allStudentsProvider);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${student.name} removed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to previous screen
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0B1E38),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B1E38), Color(0xFF1A3A5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            student.name.isNotEmpty 
                                ? student.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: student.isPaid ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  student.isPaid ? 'PAID' : 'UNPAID',
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildClickablePhoneRow(context, Icons.phone, 'Phone', student.phone, student.name),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.meeting_room, 'Room', roomNumber),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.currency_rupee, 'Monthly Rent', '₹${student.roomRent.toStringAsFixed(0)}'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.calendar_today, 'Check-in Date', student.checkInDate.isNotEmpty ? student.checkInDate : 'Not specified'),
                    if (student.parentPhoneNumber.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildClickablePhoneRow(context, Icons.contact_phone, 'Parent Phone', student.parentPhoneNumber, '${student.name}\'s Parent'),
                    ],
                    
                    // Action Buttons
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _editStudent(context),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B1E38),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _removeStudent(context, ref),
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Remove'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payments Section Header
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: const Color(0xFF0B1E38),
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Payments',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1E38),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0B1E38),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 16),

            // Placeholder for future payment details
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Payment history will be displayed here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClickablePhoneRow(BuildContext context, IconData icon, String label, String phoneNumber, String studentName) {
    return InkWell(
      onTap: () => PhoneUtils.makePhoneCall(context, phoneNumber, studentName),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              '$label: ',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      phoneNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.phone,
                    color: Colors.green[300],
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
