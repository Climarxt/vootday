import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileImage extends StatelessWidget {
  final double radius;
  final double outerCircleRadius;
  final String profileImageUrl;
  final File? profileImage;
  final bool isBrand;

  const UserProfileImage({
    super.key,
    required this.radius,
    required this.outerCircleRadius,
    required this.profileImageUrl,
    this.profileImage,
    required this.isBrand,
  });

  @override
  Widget build(BuildContext context) {
    return buildOuterCircle();
  }

  CircleAvatar buildOuterCircle() {
    return CircleAvatar(
      radius: outerCircleRadius,
      backgroundColor: grey,
      child: buildInnerCircle(),
    );
  }

  Widget buildInnerCircle() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            getProfileImage(),
            if (getNoProfileIcon() != null) getNoProfileIcon()!,
          ],
        ),
      ),
    );
  }

  Widget getProfileImage() {
    if (profileImage != null) {
      return Image.file(profileImage!);
    }
    if (profileImageUrl.isNotEmpty) {
      if (isBrand) {
        return SvgPicture.network(
          profileImageUrl,
          fit: BoxFit.contain,
        );
      } else {
        return Image(
          image: CachedNetworkImageProvider(profileImageUrl),
          fit: BoxFit.cover,
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget? getNoProfileIcon() {
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
