import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bootdv2/config/configs.dart';

class SocialNetSection extends StatelessWidget {
  const SocialNetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSocialNetworksSection(context);
  }

  Widget _buildSocialNetworksSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            AppLocalizations.of(context)!.translate('networks'),
            style: Theme.of(context).textTheme.headlineSmall!,
          ),
          const SizedBox(
            height: 6,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
