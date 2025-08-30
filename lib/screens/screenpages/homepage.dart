import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/homescreens/floordetails/floors_rooms.dart';
import 'package:hostelmate/staticscreens/dashboardcards.dart';
import 'package:hostelmate/providers/hostel_provider.dart';


class HomePageScreen extends ConsumerStatefulWidget {
  final VoidCallback onRoomTap;
  const HomePageScreen({super.key, required this.onRoomTap});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  void handleMenuSelection(String label) {
    print("Selected: $label");
  }

  @override
  Widget build(BuildContext context) {
    final hostelIdAsync = ref.watch(hostelIdProvider);
    final hostelNameAsync = ref.watch(hostelNameProvider);
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(height: 10),
            hostelNameAsync.when(
              data: (hostelName) => Text(
                'Welcome back to ${hostelName ?? 'Hostel'}', 
                style: TextStyle(fontSize: 24)
              ),
              loading: () => Text('Welcome back to Hostel', style: TextStyle(fontSize: 24)),
              error: (_, __) => Text('Welcome back to Hostel', style: TextStyle(fontSize: 24)),
            ),
            DashboardCards(),
            Expanded(
              child: hostelIdAsync.when(
                data: (hostelId) {
                  if (hostelId == null) {
                    return Center(child: Text('No hostel data found'));
                  }
                  return FloorsAndRoomsPage(
                    onRoomTap: widget.onRoomTap,
                    hostelId: hostelId,
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
