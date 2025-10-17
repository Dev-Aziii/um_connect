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
  late AnimationController _bottomNavAnimationController;
  late Animation<Offset> _bottomNavAnimation;
  final ScrollController _scrollController = ScrollController();

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
    _bottomNavAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bottomNavAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
          CurvedAnimation(
            parent: _bottomNavAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_bottomNavAnimationController.status == AnimationStatus.completed) {
        return;
      }
      _bottomNavAnimationController.forward();
    } else {
      if (_bottomNavAnimationController.status == AnimationStatus.dismissed) {
        return;
      }
      _bottomNavAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _bottomNavAnimationController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index && _scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(_widgetTitles[_selectedIndex]),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle_outlined),
                  onPressed: () {
                    context.push('/profile');
                  },
                ),
              ],
              floating: true,
              snap: true,
            ),
          ];
        },
        body: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: SlideTransition(
        position: _bottomNavAnimation,
        // --- MODIFIED SECTION ---
        // Wrap the BottomNavigationBar in a Container to add a top border
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Set the background to white
            border: Border(
              top: BorderSide(
                color: Colors
                    .grey
                    .shade300, // This creates the shadow-like outline
                width: 1.0,
              ),
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
            // Make the navigation bar's own background transparent and remove its elevation
            // so the container's decoration shows through.
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
