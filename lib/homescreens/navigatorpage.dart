import 'package:flutter/material.dart';
import 'package:hostelmate/homescreens/roomdetails/studentspage.dart';
import 'package:hostelmate/screens/screenpages/homepage.dart';
import 'package:hostelmate/models/rooms_model.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  bool showStudentPage = false;
  Room? selectedRoom;
  String? floorName;

  void goToStudentsPage(Room room, String floor) {
    setState(() {
      showStudentPage = true;
      selectedRoom = room;
      floorName = floor;
    });
  }

  void goToHomePage() {
    setState(() {
      showStudentPage = false;
      selectedRoom = null;
      floorName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showStudentPage) {
          goToHomePage(); 
          return false; 
        }
        return true; 
      },
      child: showStudentPage && selectedRoom != null
          ? RoomDetailsScreen(
              onBack: goToHomePage,
              room: selectedRoom!,
              floorName: floorName ?? 'Unknown Floor',
            )
          : HomePageScreen(onRoomTap: goToStudentsPage),
    );
  }
}
