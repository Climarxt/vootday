import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String route;
  final BuildContext context;
  const ActionButton({
    super.key,
    required this.icon,
    required this.route,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        GoRouter.of(this.context).go(route);
      },
    );
  }
}
