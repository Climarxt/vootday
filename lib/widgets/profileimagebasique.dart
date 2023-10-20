import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class ProfileImageFeed extends StatelessWidget {
  final String username;
  final String profileUrl;

  const ProfileImageFeed({
    Key? key,
    required this.username,
    required this.profileUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage(profileUrl),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            username,
            style: const TextStyle(
              color: white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(offset: Offset(-0.2, -0.2), color: Colors.grey),
                Shadow(offset: Offset(0.2, -0.2), color: Colors.grey),
                Shadow(offset: Offset(0.2, 0.2), color: Colors.grey),
                Shadow(offset: Offset(-0.2, 0.2), color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
