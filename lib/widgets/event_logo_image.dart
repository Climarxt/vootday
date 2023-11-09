import 'dart:io';

import 'package:bootdv2/config/configs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventLogoImage extends StatelessWidget {
  final double radius;
  final double outerCircleRadius;
  final String profileImageUrl;
  final File? profileImage;

  const EventLogoImage({
    super.key,
    required this.radius,
    required this.outerCircleRadius,
    required this.profileImageUrl,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return buildOuterCircle();
  }

  CircleAvatar buildOuterCircle() {
    return CircleAvatar(
      radius: outerCircleRadius,
      backgroundColor: white,
      child: buildInnerCircle(),
    );
  }

CircleAvatar buildInnerCircle() {
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey[200],
    // Utilisez SvgPicture.network pour charger une image SVG
    child: ClipOval(
      child: SvgPicture.network(
        profileImageUrl,
        fit: BoxFit.cover, // Assurez-vous que l'image SVG couvre le cercle
        width: radius * 2, // Définissez la largeur au diamètre du cercle
        height: radius * 2, // Définissez la hauteur au diamètre du cercle
      ),
    ),
  );
}


  Icon? getNoProfileIcon() {
    if (profileImage == null && profileImageUrl.isEmpty) {
      return buildDefaultProfileIcon();
    }
    return null;
  }

  Icon buildDefaultProfileIcon() {
    return Icon(
      Icons.account_circle,
      color: Colors.grey[400],
      size: radius * 2,
    );
  }
}
