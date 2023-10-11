import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bootdv2/config/configs.dart';

class SocialNetSection extends StatelessWidget {
  const SocialNetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSocialNetworksSection();
  }

  Widget _buildSocialNetworksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Réseaux",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              FaIcon(FontAwesomeIcons.facebook, color: grey, size: 20),
              FaIcon(FontAwesomeIcons.instagram, color: grey, size: 20),
              FaIcon(FontAwesomeIcons.tiktok, color: grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
