import 'dart:io';

import 'package:bootdv2/config/configs.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class UserProfileImage extends StatelessWidget {
  final double radius;
  final double outerCircleRadius;
  final String profileImageUrl;
  final File? profileImage;

  const UserProfileImage({
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
      backgroundImage: getProfileImage(),
      child: getNoProfileIcon(),
    );
  }

  ImageProvider<Object>? getProfileImage() {
    if (profileImage != null) {
      return FileImage(profileImage!);
    }
    if (profileImageUrl.isNotEmpty) {
      return CachedNetworkImageProvider(profileImageUrl);
    }
    return null;
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
