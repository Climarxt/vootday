import 'package:flutter/material.dart';
import '/screens/profile/widgets/widgets.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    Key? key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.posts,
    required this.followers,
    required this.following,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildStatisticsRow(),
        const SizedBox(height: 8.0),
        buildProfileButton(),
      ],
    );
  }

  Row buildStatisticsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stats(count: posts, label: 'posts'),
        Stats(count: followers, label: 'followers'),
        Stats(count: following, label: 'following'),
        Stats(count: 4, label: 'stars'),
      ],
    );
  }

  Padding buildProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ProfileButton(
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
      ),
    );
  }
}

