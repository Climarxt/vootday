import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileSliverList extends StatelessWidget {
  final ProfileState state;

  const ProfileSliverList({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile1.jpg'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Christian Bastide',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: black),
                ),
                const SizedBox(height: 12),
                ProfileStats(
                  isCurrentUser: state.isCurrentUser,
                  isFollowing: state.isFollowing,
                  posts: state.posts.length,
                  followers: state.user.followers,
                  following: state.user.following,
                ),
                const SizedBox(height: 8), // Bottom space
              ],
            ),
          ),
        ],
      ),
    );
  }
}
