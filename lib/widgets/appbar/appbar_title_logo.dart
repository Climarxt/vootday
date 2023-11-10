import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarTitleLogo extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoUrl; // URL du fichier SVG

  const AppBarTitleLogo(
      {super.key, required this.title, required this.logoUrl});

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
          ClipOval(
            child: SvgPicture.network(
              logoUrl,
              width: 40, // Taille du SVG
              height: 40, // Taille du SVG
              fit: BoxFit.cover, // Pour s'assurer que l'image remplit le cercle
            ),
          ),
          const SizedBox(width: 8), // Espace entre l'avatar et le titre
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.black),
          ),
        ],
      ),
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
