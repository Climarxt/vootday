import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import '/screens/profile/widgets/widgets.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    super.key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.posts,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildStatisticsRow(context),
        const SizedBox(height: 8.0),
        buildProfileButton(),
      ],
    );
  }

  Row buildStatisticsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stats(count: followers, label: AppLocalizations.of(context)!.translate('followersCap')),
        ),
        Stats(count: posts, label: 'OOTD'),
        const Expanded(
          child: Stats(count: 3532, label: 'VOOTD'),
        ),
      ],
    );
  }

  Padding buildProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0),
      child: ProfileButton(
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
      ),
    );
  }
}
