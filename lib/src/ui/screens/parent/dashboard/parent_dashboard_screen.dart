import 'package:flutter/material.dart';
import 'package:minda_application/src/ui/screens/parent/dashboard/account/parent_profile_screen.dart';
import 'package:minda_application/src/ui/screens/parent/dashboard/main_screen.dart';

import 'child/children_list_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _selectedIndex = 0;

  // Handle item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      Center(child: MainDashboard()),
      Center(child: ChildrenListScreen()),
      Center(child: ParentProfileScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        // Color for selected item label and icon
        unselectedItemColor: Color(0xFFADA1F3),
        // Color for unselected labels
        selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
        unselectedIconTheme: const IconThemeData(color: Color(0xFFB7ABFF)),
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care_rounded),
            label: 'Child',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
