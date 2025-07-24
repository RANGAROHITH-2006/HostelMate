import 'package:flutter/material.dart';
import 'package:hostelmate/homescreens/floordetails/floors_rooms.dart';
import 'package:hostelmate/staticscreens/dashboardcards.dart';


class HomePageScreen extends StatefulWidget {
  final VoidCallback onRoomTap;
  const HomePageScreen({super.key, required this.onRoomTap});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  void handleMenuSelection(String label) {
    print("Selected: $label");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('Welcome back to name', style: TextStyle(fontSize: 24)),
            DashboardCards(),
            Expanded(
              child: FloorsAndRoomsPage(
                onRoomTap: widget.onRoomTap ,
                hostelId: '395bc6e2-c506-4939-a07b-23a03ec494d0',
                floorId:'5589ea91-b1da-4e62-b485-92a7798b146e'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
