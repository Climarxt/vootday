import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import '/screens/profile/widgets/widgets.dart';

class ProfileBrandStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int events;
  final int followers;
  final int following;

  const ProfileBrandStats({
    super.key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.events,
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
          child: Stats(
              count: followers,
              label: AppLocalizations.of(context)!.translate('followersCap')),
        ),
        Stats(count: events, label: 'EVENTS'),
        Expanded(
          child: Stats(
              count: 2532,
              label: AppLocalizations.of(context)!.translate('participantsCAP')),
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
