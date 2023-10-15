import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarProfile extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarProfile({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
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
