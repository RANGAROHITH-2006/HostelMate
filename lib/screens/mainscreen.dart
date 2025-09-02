import 'package:flutter/material.dart';
import 'package:hostelmate/homescreens/navigatorpage.dart';
import 'package:hostelmate/screens/screenpages/expenditure.dart';
import 'package:hostelmate/screens/screenpages/unpaidstatus.dart';
import 'package:hostelmate/staticscreens/sidenavbar.dart';
import 'package:hostelmate/staticscreens/profilemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void handleMenuSelection(String label) {
    print("Selected: $label");
    
    if (label == 'Students') {
      context.push('/all_students');
    }
    // Add other menu items here as needed
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  final List<Widget> _screens =  [
    NavigatorPage(),
    Unpaidstatus(),
    Expenditure(),
    Center(child: Text("Plans")), 
  ];

  @override
  Widget build(BuildContext context) {
    String email = 'rohith@example.com';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E38),
        title: const Text(
          'Hostel Mate',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white70),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu,color:  Colors.white70,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ProfileMenu(
              email: email,
              name: "",
              onLogout: () async {
              await logout();
            context.go('/loginpage');
              },
            ),
          ),
        ],
      ),
      drawer: SideNavBar(onItemSelected: handleMenuSelection),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  const Color(0xFF0B1E38),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            label: "Un-paid",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            label: "Expenditure",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_outlined),
            label: "Plans",
          ),
        ],
      ),
    );
  }
}
