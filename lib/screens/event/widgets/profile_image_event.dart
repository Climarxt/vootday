import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileImageEvent extends StatelessWidget {
  final String title;
  final int likes;
  final String description;
  final String profileImage;
  final List<String> tags;
  final VoidCallback? onTitleTap;

  const ProfileImageEvent({
    super.key,
    required this.title,
    required this.likes,
    required this.description,
    required this.profileImage,
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
                child: ClipOval(
                  child: SvgPicture.network(
                    profileImage,
                    fit: BoxFit.cover,
                  ),
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
