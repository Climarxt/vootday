import 'package:flutter/material.dart';

class ProfileUserBio extends StatelessWidget {
  final String username;
  final String bio;

  const ProfileUserBio({
    Key? key,
    required this.username,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            username,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            bio,
            style: const TextStyle(fontSize: 15.0),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
