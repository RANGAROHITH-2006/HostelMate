import 'package:flutter/material.dart';

class SideNavBar extends StatefulWidget {
  final Function(String) onItemSelected;

  const SideNavBar({super.key, required this.onItemSelected});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  String selected = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
       decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B1E38), Color(0xFF1A3A5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.apartment_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Rohith', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Management Portal', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

        
            _sidebarItem(Icons.dashboard, 'Dashboard'),
            _sidebarItem(Icons.people_alt_outlined, 'Students'),
            _sidebarItem(Icons.group_outlined, 'Groups'),
            _sidebarItem(Icons.message_outlined, 'Messages'),
            _sidebarItem(Icons.settings, 'Settings'),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Hostel Mate v1.0', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('Management System', style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label) {
    final bool isSelected = selected == label;

    return InkWell(
      onTap: () {
        setState(() {
          selected = label;
        });
        widget.onItemSelected(label);
        Navigator.pop(context); 
      },
      onHover: (hovering) {
        
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.white70),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




final List<Color> avatarColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
    ];