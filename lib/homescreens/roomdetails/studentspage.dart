import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';
import 'package:hostelmate/providers/student_provider.dart';
import 'package:hostelmate/models/rooms_model.dart';
import 'package:hostelmate/homescreens/roomdetails/add_student_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

final List<Color> avatarColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.brown,
  Colors.indigo,
];

class RoomDetailsScreen extends ConsumerWidget {
  final Room room;
  final String floorName;
  final VoidCallback onBack;

  const RoomDetailsScreen({
    super.key,
    required this.room,
    required this.floorName,
    required this.onBack,
  });

  // Function to get a consistent color for each student based on their ID
  Color _getAvatarColor(String studentId) {
    final hash = studentId.hashCode;
    return avatarColors[hash.abs() % avatarColors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStudents = ref.watch(allStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${room.roomNumber}'),
        backgroundColor: const Color(0xFF0B1E38),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: allStudents.when(
        data: (students) {
          final roomStudents = students.where((s) => s.roomId == room.id).toList();
          final occupancyPercentage = (roomStudents.length / room.capacity * 100).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B1E38), Color(0xFF1A3A5C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.bed,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Room ${room.roomNumber}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  floorName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(Icons.people, color: Colors.white70, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '${roomStudents.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Occupied',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(Icons.bed, color: Colors.white70, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '${room.capacity}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Total Beds',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(Icons.percent, color: Colors.white70, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '$occupancyPercentage%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Occupancy',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: roomStudents.length / room.capacity,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          occupancyPercentage >= 100 ? Colors.red : 
                          occupancyPercentage >= 80 ? Colors.orange : Colors.green,
                        ),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Students Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Current Students",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF0B1E38),
                      ),
                    ),
                    if (roomStudents.length < room.capacity)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddStudentPage(
                                hostelId: room.hostelId,
                                roomId: room.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text("Add Student"),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Students List
                if (roomStudents.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No students in this room',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add students to fill the ${room.capacity} available beds',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roomStudents.length,
                    itemBuilder: (context, index) {
                      final student = roomStudents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: CircleAvatar(
                            backgroundColor: _getAvatarColor(student.id),
                            child: Text(
                              student.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            student.name.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      student.phone,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'call',
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, size: 18, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Call', style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_circle, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Remove', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'call') {
                                // Show permission dialog first
                                bool? shouldProceed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Make Phone Call'),
                                    content: Text('Do you want to call ${student.name} at ${student.phone}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );

                                if (shouldProceed == true) {
                                  // Request phone permission
                                  PermissionStatus permissionStatus = await Permission.phone.request();
                                  
                                  if (permissionStatus.isGranted || permissionStatus.isLimited) {
                                    try {
                                      // Try different approaches to launch phone dialer
                                      final phoneNumber = student.phone;
                                      
                                      // Method 1: Use tel: scheme with external app mode
                                      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
                                      bool launched = false;
                                      
                                      try {
                                        await launchUrl(
                                          telUri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                        launched = true;
                                      } catch (e) {
                                        print('Method 1 failed: $e');
                                      }
                                      
                                      // Method 2: If method 1 fails, try with platform default
                                      if (!launched) {
                                        try {
                                          await launchUrl(telUri, mode: LaunchMode.platformDefault);
                                          launched = true;
                                        } catch (e) {
                                          print('Method 2 failed: $e');
                                        }
                                      }
                                      
                                      // Method 3: If still fails, try without specifying mode
                                      if (!launched) {
                                        try {
                                          await launchUrl(telUri);
                                          launched = true;
                                        } catch (e) {
                                          print('Method 3 failed: $e');
                                        }
                                      }
                                      
                                      if (!launched) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Unable to open phone dialer. Please check if a phone app is installed.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Phone permission denied. Please grant permission in settings.'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                }
                              } else if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddStudentPage(
                                      hostelId: student.hostelId,
                                      roomId: student.roomId,
                                      isEditing: true,
                                      student: student,
                                    ),
                                  ),
                                );
                              } else if (value == 'remove') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Remove Student'),
                                    content: Text('Are you sure you want to remove ${student.name}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await ref.read(studentProvider.notifier).removeStudent(student.id);
                                            Navigator.pop(context); // Close the popup
                                            ref.invalidate(allStudentsProvider); // Refresh the student list
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${student.name} removed successfully!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            Navigator.pop(context); // Close the popup
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error removing student: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(allStudentsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
