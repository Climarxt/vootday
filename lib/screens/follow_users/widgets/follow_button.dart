import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_cubit.dart';
import 'package:bootdv2/screens/follow_users/following_users/following_users_cubit.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final String userId;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.userId,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  void refreshFollowers() {
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.uid;
    context.read<FollowersUsersCubit>().fetchUserFollowers(userId!);
    context.read<FollowingUsersCubit>().fetchUserFollowing(userId);
  }

  @override
  Widget build(BuildContext context) {
    return buildFollowButton(context);
  }

  // Builds the 'Follow/Unfollow' button.
  TextButton buildFollowButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rayon des bords arrondis
        ),
      ),
      onPressed: () {
        debugPrint('Follow button pressed');
        toggleFollowStatus(context);
      },
      child: Text(
        widget.isFollowing
            ? AppLocalizations.of(context)!.translate('unfollow')
            : AppLocalizations.of(context)!.translate('follow'),
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }

// Toggles the follow status of the profile.
  void toggleFollowStatus(BuildContext context) {
    debugPrint('Toggling follow status. Current status: ${widget.isFollowing}');
    if (widget.isFollowing) {
      debugPrint('Unfollowing user');
      context
          .read<ProfileBloc>()
          .add(ProfileUnfollowUserWithUserId(unfollowUserId: widget.userId));
      refreshFollowers();
    } else {
      debugPrint('Following user');
      context
          .read<ProfileBloc>()
          .add(ProfileFollowUserWithUserId(followUserId: widget.userId));
    }
    refreshFollowers();
  }
}
