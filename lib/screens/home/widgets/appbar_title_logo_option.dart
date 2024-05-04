import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarTitleLogoOption extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String eventId;
  final String logoUrl; // URL du fichier SVG

  const AppBarTitleLogoOption(
      {super.key, required this.title, required this.logoUrl, required this.eventId});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.black),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _navigateToEventScreen(context),
          icon: const Icon(
            Icons.event,
            color: Colors.black,
          ),
        ),
      ],
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  void _navigateToEventScreen(BuildContext context) {
    GoRouter.of(context)
        .push('/feedevent/$eventId/event', extra: eventId);
  }
}