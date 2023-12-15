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
      bottomNavigationBar: !(currentLocation == '/profile/create' ||
              currentLocation.endsWith('/create'))
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Calendar'),
                BottomNavigationBarItem(
                    icon: _buildSwipeIcon(context), label: 'Swipe'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Profile')
              ],
              backgroundColor: white,
              currentIndex: navigationShell.currentIndex,
              onTap: (int index) => _onTap(context, index),
              unselectedItemColor: greyDark,
              selectedItemColor: black,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            )
          : null, // Ne pas afficher la barre de navigation
    );
  }

  // Méthode pour créer un widget personnalisé pour l'icône "Swipe"
  Widget _buildSwipeIcon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [couleurBleu1, couleurBleuClair1],
        ),
      ),
      child: Icon(Icons.swipe, color: white),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
