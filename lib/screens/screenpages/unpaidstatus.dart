import 'package:flutter/material.dart';

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

class Unpaidstatus extends StatelessWidget {
   Unpaidstatus({super.key});

  final List<Student> students = [
     Student(name: 'Rohith', roomNumber: '101', feeAmount: 5000, isUnpaid: true),
     Student(name: 'Satish', roomNumber: '101', feeAmount: 5000, isUnpaid: true),
     Student(name: 'Anil', roomNumber: '101', feeAmount: 5000, isUnpaid: true),
     Student(name: 'Kiran', roomNumber: '102', feeAmount: 5200, isUnpaid: true),
     Student(name: 'Manoj', roomNumber: '103', feeAmount: 4800, isUnpaid: true),
     Student(name: 'Pranay', roomNumber: '103', feeAmount: 5000, isUnpaid: true),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Fee Details')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Room No: ${student.roomNumber}'),
                  Text('Fee: ₹${student.feeAmount.toStringAsFixed(2)}'),
                ],
              ),
              trailing: Chip(
                label: Text(
                  student.isUnpaid ? 'Unpaid' : 'Paid',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: student.isUnpaid ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}