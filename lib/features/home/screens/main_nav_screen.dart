import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.celebration_outlined,
    Icons.campaign_outlined,
    Icons.person_outline,
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
        height: 65.0,
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
        items: List.generate(icons.length, (index) {
          return Icon(icons[index], size: 26, color: Colors.white);
        }),
      ),
    );
  }
}
