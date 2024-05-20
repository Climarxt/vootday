import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.appTitle,
    required this.navigationShell,
    this.appBar,
    Key? key,
    required this.currentLocation,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final String appTitle;
  final StatefulNavigationShell navigationShell;
  final AppBar? appBar;
  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: navigationShell,
      bottomNavigationBar: !(currentLocation == '/profile/create' ||
              currentLocation == '/profile/create/brand' ||
              currentLocation.endsWith('/create'))
          ? SizedBox(
              height: 82,
              child: BottomNavigationBar(
                selectedFontSize: 0,
                items: [
                  _buildNavBarItem(context, Icons.home, 'Home', 0),
                  _buildNavBarItem(
                      context, Icons.calendar_month, 'Calendar', 1),
                  _buildNavBarItem(context, Icons.swipe, 'Swipe', 2),
                  _buildNavBarItem(context, Icons.search, 'Search', 3),
                  _buildNavBarItem(context, Icons.account_circle, 'Profile', 4),
                ],
                backgroundColor: Colors.white,
                currentIndex: navigationShell.currentIndex,
                onTap: (int index) => _onTap(context, index),
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.black,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
              ),
            )
          : null,
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      BuildContext context, IconData icon, String label, int index) {
    bool isSelected = navigationShell.currentIndex == index;
    return BottomNavigationBarItem(
      icon: _customIcon(context, icon, isSelected: isSelected),
      label: label,
    );
  }

  Widget _customIcon(BuildContext context, IconData icon,
      {bool isSelected = false}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 1), // Reduces vertical padding
      child: Icon(
        icon,
        color: isSelected ? Colors.black : Colors.grey,
        size: isSelected ? 32 : 24,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
