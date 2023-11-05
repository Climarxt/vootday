import 'package:bootdv2/config/configs.dart';
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
      bottomNavigationBar: currentLocation != '/profile/create' 
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Calendar'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.swipe), label: 'Swipe'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Profile')
              ],
              backgroundColor: white,
              currentIndex: navigationShell.currentIndex,
              onTap: (int index) => _onTap(context, index),
              unselectedItemColor: Colors.black,
              selectedItemColor: couleurBleuClair2,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            )
          : null, // Ne pas afficher la barre de navigation
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
