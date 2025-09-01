import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';
import 'package:hostelmate/providers/hostel_provider.dart';

class DashboardCards extends ConsumerWidget {
  const DashboardCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStudentsAsync = ref.watch(allStudentsProvider);
    final hostelIdAsync = ref.watch(hostelIdProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: hostelIdAsync.when(
                  data: (hostelId) {
                    if (hostelId == null) {
                      return _buildCard(Icons.group, "Total Students", 0, Colors.blue.shade100, Colors.blue);
                    }
                    
                    return allStudentsAsync.when(
                      data: (allStudents) {
                        final hostelStudents = allStudents.where((s) => s.hostelId == hostelId).toList();
                        return _buildCard(Icons.group, "Total Students", hostelStudents.length, Colors.blue.shade100, Colors.blue);
                      },
                      loading: () => _buildLoadingCard(Icons.group, "Total Students", Colors.blue.shade100, Colors.blue),
                      error: (_, __) => _buildCard(Icons.group, "Total Students", 0, Colors.blue.shade100, Colors.blue),
                    );
                  },
                  loading: () => _buildLoadingCard(Icons.group, "Total Students", Colors.blue.shade100, Colors.blue),
                  error: (_, __) => _buildCard(Icons.group, "Total Students", 0, Colors.blue.shade100, Colors.blue),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildCard(Icons.group_outlined, "Active Groups", 0, Colors.green.shade100, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildCard(Icons.message_outlined, "Message Sent", 0, Colors.purple.shade100, Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildCard(IconData icon, String title, int count, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(IconData icon, String title, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
