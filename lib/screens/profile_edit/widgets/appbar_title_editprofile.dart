import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class AppBarEditProfile extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const AppBarEditProfile({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: black),
      centerTitle: true,
      title: Text(
        title!,
        style:
            Theme.of(context).textTheme.headlineMedium!.copyWith(color: black),
      ),
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
