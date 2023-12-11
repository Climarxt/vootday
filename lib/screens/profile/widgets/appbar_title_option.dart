import 'package:flutter/material.dart';

class AppBarTitleOption extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarTitleOption({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
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
          onPressed: () {},
          icon: const Icon(
            Icons.view_headline,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
