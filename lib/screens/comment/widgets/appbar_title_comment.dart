import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class AppBarComment extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String postId;
  const AppBarComment({super.key, required this.title, required this.postId});

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
