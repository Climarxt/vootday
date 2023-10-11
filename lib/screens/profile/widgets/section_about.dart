import 'package:flutter/material.dart';
import '../bloc/profile_bloc.dart';

class AboutSection extends StatelessWidget {
  final ProfileState state;
  const AboutSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildAboutSection(state);
  }

  Widget _buildAboutSection(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "A propos",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            state.user.bio,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
