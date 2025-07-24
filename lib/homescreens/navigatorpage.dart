import 'package:flutter/material.dart';
import 'package:hostelmate/homescreens/roomdetails/studentspage.dart';
import 'package:hostelmate/screens/screenpages/homepage.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  bool showStudentPage = false;


  void goToStudentsPage() {
    setState(() {
      showStudentPage = true;
    });
  }

  void goToHomePage() {
    setState(() {
      showStudentPage = false;
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
      child: showStudentPage
          ? RoomDetailsScreen(onBack: goToHomePage , roomId: '1122', floorName: '1',) 
          : HomePageScreen(onRoomTap: goToStudentsPage),
    );
  }
}
