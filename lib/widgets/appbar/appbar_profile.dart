import 'package:flutter/material.dart';

class AppBarProfile extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarProfile({super.key, required this.title});

  @override
  Size get preferredSize => Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          centerTitle: true,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium // note: headlineMedium is not a predefined style. I replaced it with headline6.
                !.copyWith(color: Colors.black),
          ),
          toolbarHeight: 62,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // Action for button 1
              },
              icon: Icon(
                Icons.notifications, // Replace with your desired icon
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                // Action for button 2
              },
              icon: Icon(
                Icons.view_headline, // Replace with your desired icon
                color: Colors.black,
              ),
            ),
          ],
        );
  }
}
