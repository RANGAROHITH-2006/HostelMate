import 'package:flutter/material.dart';
import 'package:hostelmate/staticscreens/sidenavbar.dart';

class ProfileMenu extends StatelessWidget {
  final String email;
  final String name;
  final VoidCallback onLogout;

  const ProfileMenu({
    super.key,
    required this.email,
    required this.name,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final int colorIndex = email.codeUnitAt(0) % avatarColors.length;
    final Color avatarColor = avatarColors[colorIndex];

    return PopupMenuButton<int>(
      color: Colors.white,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) {
        if (value == 3) {
          onLogout();
        } else if (value == 1) {
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Account',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(fontSize: 12)),
              const Divider(),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.settings, size: 18),
              SizedBox(width: 10),
              Text("Settings"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: Colors.red),
              SizedBox(width: 10),
              Text("Logout", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: CircleAvatar(
        backgroundColor:avatarColor,
        radius: 18,
        child: Text(
          email[0].toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
