import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:um_connect/features/announcements/screens/announcements_list_screen.dart';
import 'package:um_connect/features/events/screens/events_list_screen.dart';
import 'package:um_connect/features/home/screens/home_screen.dart';
import 'package:um_connect/features/profile/screens/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const EventsListScreen(),
    const AnnouncementsScreen(),
    const ProfileScreen(),
    const Center(child: Text("Settings Screen")),
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.campaign,
    Icons.person,
    Icons.settings,
  ];

  final List<String> labels = [
    'Home',
    'Events',
    'Announce',
    'Profile',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _widgetOptions[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        color: Color.fromARGB(40, 111, 83, 86),
        buttonBackgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
        items: List.generate(icons.length, (index) {
          bool isSelected = index == _selectedIndex;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons[index],
                size: isSelected ? 26 : 24,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(height: 2),
              if (!isSelected)
                Text(
                  labels[index],
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
            ],
          );
        }),
      ),
    );
  }
}
