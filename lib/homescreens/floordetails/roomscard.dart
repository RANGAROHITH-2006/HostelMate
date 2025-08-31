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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R .${room.roomNumber}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete),
                color: Colors.orange,
              ),
            ],
          ),          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bed, size: 20, color: Colors.black),
                  const SizedBox(width: 4),
                  Text(" ${room.capacity}", style: TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4),
                  Text(" ${room.capacity}", style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
