import 'package:flutter/material.dart';

Future<void> showAddFloorDialog({
  required BuildContext context,
  required Function(String) onCreate,
}) async {
  final controller = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Floor'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Floor Number',
            hintText: 'Add Floor Number',
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onCreate(controller.text.trim());
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Create Floor'),
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String word,
  required Future<void> Function() onConfirm,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete $title'),
        content:  Text(
          'Are you sure you want to delete this $title? This action will remove all $word.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              print('Delete button clicked');
              Navigator.of(context).pop();
              await onConfirm();
            },
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 227, 95, 86),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      );
    },
  );
}


Future<void> showAddRoomDialog({
  required BuildContext context,
  required Function(String roomNumber, String capacity) onCreate,
}) async {
  final roomNumberController = TextEditingController();
  final capacityController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: roomNumberController,
              decoration: const InputDecoration(
                labelText: 'Room Number',
                hintText: 'Enter room number',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacity',
                hintText: 'Enter room capacity',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              final roomNumber = roomNumberController.text.trim();
              final capacity = capacityController.text.trim();
              if (roomNumber.isNotEmpty && capacity.isNotEmpty) {
                onCreate(roomNumber, capacity);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Create Room'),
          ),
        ],
      );
    },
  );
}
