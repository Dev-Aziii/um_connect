import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:um_connect/features/announcements/screens/announcements_list_screen.dart';
import 'package:um_connect/features/calendar/screens/calendar_screen.dart';
import 'package:um_connect/features/events/screens/events_list_screen.dart';
import 'package:um_connect/features/home/screens/home_screen.dart';
import 'package:um_connect/shared_widgets/app_drawer.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _appBarAnimation;
  late Animation<Offset> _bottomNavAnimation;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const EventsListScreen(),
    const AnnouncementsScreen(),
    const CalendarScreen(),
  ];

  final List<String> _widgetTitles = <String>[
    'UM-Connect',
    'Events',
    'Announcements',
    'Calendar',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _appBarAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -1), // Slides up
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _bottomNavAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 1), // Slides down
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // When switching tabs, show the bars again
    _animationController.reverse();
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      final UserScrollNotification userScroll = notification;
      switch (userScroll.direction) {
        case ScrollDirection.forward: // Scrolling up
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          }
          break;
        case ScrollDirection.reverse: // Scrolling down
          if (_animationController.status == AnimationStatus.dismissed) {
            _animationController.forward();
          }
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
      // --- BODY MODIFIED ---
      // The body is now a Stack to layer the content and the AppBar.
      body: Stack(
        children: [
          // Layer 1: The Page Content
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: _widgetOptions[_selectedIndex],
          ),
          // Layer 2: The Animated AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _appBarAnimation,
              child: AppBar(
                title: Text(_widgetTitles[_selectedIndex]),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {
                      context.push('/profile');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SlideTransition(
        position: _bottomNavAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.celebration_outlined),
                activeIcon: Icon(Icons.celebration),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.campaign_outlined),
                activeIcon: Icon(Icons.campaign),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
