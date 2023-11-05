import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/widgets.dart';

class ProfileInfo extends StatelessWidget {
  final ProfileState state;
  const ProfileInfo({
    super.key, 
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return buildProfileInfo();
  }

  Widget buildProfileInfo() {
    return Column(
      children: [
        buildUserProfile(state),
        // buildUserBio(state),
      ],
    );
  }

  Padding buildUserProfile(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 125.0, 24.0, 0),
      child: Column(
        children: [
          UserProfileImage(
            radius: 40.0,
            outerCircleRadius: 41,
            profileImageUrl: state.user.profileImageUrl,
          ),
          ProfileStats(
            isCurrentUser: state.isCurrentUser,
            isFollowing: state.isFollowing,
            posts: state.posts.length,
            followers: state.user.followers,
            following: state.user.following,
          ),
        ],
      ),
    );
  }

  Padding buildUserBio(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: ProfileUserBio(
        username: state.user.username,
        bio: state.user.bio,
      ),
    );
  }
}
