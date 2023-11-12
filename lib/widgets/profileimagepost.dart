import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class ProfileImagePost extends StatelessWidget {
  final String title;
  final int likes;
  final String description;
  final ImageProvider<Object>? profileImageProvider;
  final List<String> tags;
  final VoidCallback? onTitleTap;

  const ProfileImagePost({
    super.key,
    required this.title,
    required this.likes,
    required this.description,
    required this.profileImageProvider,
    required this.tags,
    this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: onTitleTap,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: greyDark,
                child: CircleAvatar(
                  radius: 39,
                  backgroundImage: profileImageProvider,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTitleTap,
                  child: Text(
                    title,
                    style: AppTextStyles.titleLargeBlackBold(context),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '$likes',
                      style: AppTextStyles.bodyStyle(context),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.emoji_events,
                      color: black,
                      size: 12,
                    ),
                  ],
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
              children: <TextSpan>[
                TextSpan(
                  text: description,
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
              children: tags.map((tag) {
                return WidgetSpan(
                  child: InkWell(
                    onTap: () {
                      // Gérez l'événement de clic ici, par exemple, naviguez vers un écran de recherche avec le tag.
                      print('Tag "$tag" a été cliqué');
                    },
                    child: Text(
                      '#$tag ',
                      style: AppTextStyles.bodyTag(context),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
