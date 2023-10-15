import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SliverAppBarProfile extends StatelessWidget {
  final String title;
  const SliverAppBarProfile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned:
          true, // Set to true if you want the app bar to stay visible when scrolling
      expandedHeight: 62.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () => GoRouter.of(context).go('/profile/notifications'),
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () => GoRouter.of(context).go('/profile/settings'),
          icon: const Icon(
            Icons.view_headline,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
