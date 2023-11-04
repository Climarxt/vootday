import 'package:flutter/material.dart';

class AppBarWhite extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWhite({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
