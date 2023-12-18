import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.isFollowing,
  });

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
          // Ajoute des bords arrondis
          borderRadius: BorderRadius.circular(10), // Rayon des bords arrondis
        ),
      ),
      onPressed: () => toggleFollowStatus(context),
      child: Text(
        isFollowing
            ? AppLocalizations.of(context)!.translate('unfollow')
            : AppLocalizations.of(context)!.translate('follow'),
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }

  // Toggles the follow status of the profile.
  void toggleFollowStatus(BuildContext context) {
    isFollowing
        ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
        : context.read<ProfileBloc>().add(ProfileFollowUser());
  }
}
