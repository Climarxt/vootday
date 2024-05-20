import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialNetSection extends StatelessWidget {
  final ProfileState state;
  const SocialNetSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildSocialNetworksSection(state, context);
  }

  Widget _buildSocialNetworksSection(ProfileState state, BuildContext context) {
    final socialInstagram = state.user.socialInstagram;
    final socialTikTok = state.user.socialTiktok;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('socialNetworks'),
            style: AppTextStyles.titleLargeBlackBold(context),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  if (socialInstagram.isNotEmpty) {
                    final url = Uri.parse(
                        'https://www.instagram.com/$socialInstagram/');
                    _launchURL(url);
                  }
                },
                child: FaIcon(
                  FontAwesomeIcons.instagram,
                  color: socialInstagram.isNotEmpty ? Colors.red : Colors.grey,
                  size: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (socialTikTok.isNotEmpty) {
                    final url =
                        Uri.parse('https://www.tiktok.com/@$socialTikTok');
                    _launchURL(url);
                  }
                },
                child: FaIcon(
                  FontAwesomeIcons.tiktok,
                  color: socialTikTok.isNotEmpty ? Colors.black : Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
