import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final goRouter = GoRouter.of(context);
        goRouter.go('/notifications');
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Colors.amber,
          child: Center(
            child: Text(
              'Message Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
    );
  }
}
