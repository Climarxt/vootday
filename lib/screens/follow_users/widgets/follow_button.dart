import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final String userId;
  final VoidCallback onFollowStatusChanged;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.userId,
    required this.onFollowStatusChanged,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    // Show 'Edit Profile' button for the current user, otherwise show 'Follow/Unfollow' button.
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
    } else {
      debugPrint('Following user');
      context
          .read<ProfileBloc>()
          .add(ProfileFollowUserWithUserId(followUserId: widget.userId));
    }
    widget.onFollowStatusChanged();
  }
}
