import 'package:bootdv2/config/configs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bootdv2/models/wip/model.dart';

class FollowUsersTile extends StatelessWidget {
  final NotifWIP notification;

  const FollowUsersTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundImage: CachedNetworkImageProvider(
              notification.fromUser.profileImageUrl,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.fromUser.username,
                  style: AppTextStyles.titleLargeBlackBold(context),
                ),
                Text(
                  "Prénom Nom",
                  style: AppTextStyles.subtitleLargeGrey(context),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: couleurBleuClair2,
            ),
            child: Text(
              'Suivi(e)',
              style: AppTextStyles.titleLargeWhiteBold(context),
            ),
          ),
        ],
      ),
    );
  }
}
