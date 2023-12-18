import 'package:flutter/material.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';

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
          _buildAvatar(),
          const SizedBox(width: 10),
          _buildUserInfo(context),
          _buildFollowButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 27,
      backgroundImage: NetworkImage(user.profileImageUrl.isNotEmpty
          ? user.profileImageUrl
          : 'path/to/default/image'), // Ajoutez un chemin pour une image par défaut
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Expanded(
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
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Suivi(e)',
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }
}
