import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MySliverAppBarProfile extends StatefulWidget {
  final String title;
  const MySliverAppBarProfile({super.key, required this.title});

  @override
  State<MySliverAppBarProfile> createState() => _MySliverAppBarProfileState();
}

class _MySliverAppBarProfileState extends State<MySliverAppBarProfile> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 62.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      leading: IconButton(
          onPressed: () => GoRouter.of(context).go('/profile/create'),
          icon: const Icon(
            Icons.add_box,
            color: Colors.black,
          ),
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