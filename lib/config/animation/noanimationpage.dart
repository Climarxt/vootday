
import 'package:flutter/material.dart';

class NoAnimationPage extends MaterialPage {
  @override
  // ignore: overridden_fields
  final Widget child;
  NoAnimationPage({required this.child})
      : super(key: ValueKey(child), child: child);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
    );
  }
}