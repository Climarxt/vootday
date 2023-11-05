import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class ProfileImagePost extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider<Object>? profileImageProvider;

  const ProfileImagePost({
    super.key,
    required this.title,
    required this.subtitle,
    this.profileImageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: greyDark,
              child: CircleAvatar(
                radius: 39,
                backgroundImage: profileImageProvider,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLargeBlackBold(context),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.subtitleLargeGrey(context),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 300,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: AppTextStyles.bodyStyle(context),
              children: const <TextSpan>[
                TextSpan(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum. Donec in efficitur leo. Proin quis tortor orci. Etiam at risus et justo dignissim congue.",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 300,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: AppTextStyles.bodyTag(context),
              children: const <TextSpan>[
                TextSpan(
                  text: "#Nike #Sandro #Stussy #Obey",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
