import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.appTitle,
    required this.navigationShell,
    this.appBar,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final String appTitle;
  final StatefulNavigationShell navigationShell;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.swipe), label: 'Swipe'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile')
        ],
        backgroundColor: white,
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
        unselectedItemColor: Colors.black,
        selectedItemColor: couleurBleuClair2,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
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
