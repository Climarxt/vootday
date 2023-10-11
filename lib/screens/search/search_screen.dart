import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final goRouter = GoRouter.of(context);
        goRouter.go('/swipe');
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Colors.amber,
          child: Center(
            child: Text(
              'Search Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
    );
  }
}