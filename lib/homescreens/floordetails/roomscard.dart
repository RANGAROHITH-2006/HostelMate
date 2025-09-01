import 'package:flutter/material.dart';
import 'package:hostelmate/models/rooms_model.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final String hostelId;
  final VoidCallback onDelete;
 
  const RoomCard({required this.room, required this.hostelId, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'R.${room.roomNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.delete,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),          
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bed, size: 16, color: Colors.black),
                  const SizedBox(width: 2),
                  Text("${room.capacity}", style: const TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 2),
                  Text("${room.capacity}", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
