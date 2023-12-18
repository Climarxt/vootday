import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:flutter/material.dart';

class FollowUsersTile extends StatelessWidget {
  final User user;

  const FollowUsersTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundImage: NetworkImage(user.profileImageUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: AppTextStyles.titleLargeBlackBold(context),
                ),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: AppTextStyles.subtitleLargeGrey(context),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              backgroundColor: couleurBleuClair2,
              shape: RoundedRectangleBorder(
                // Ajoute des bords arrondis
                borderRadius:
                    BorderRadius.circular(10), // Rayon des bords arrondis
              ),
            ),
            child: Text(
              'Suivi(e)',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: white),
            ),
          ),
        ],
      ),
    );
  }
}
