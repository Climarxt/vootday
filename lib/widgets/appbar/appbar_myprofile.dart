import 'package:bootdv2/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SliverAppBarMyProfile extends StatefulWidget {
  final String title;
  const SliverAppBarMyProfile({super.key, required this.title});

  @override
  State<SliverAppBarMyProfile> createState() => _SliverAppBarMyProfileState();
}

class _SliverAppBarMyProfileState extends State<SliverAppBarMyProfile> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 62.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: black),
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
          Icons.add,
          color: Colors.black,
        ),
      ),
      actions: [
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
