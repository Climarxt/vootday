import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileButton extends StatelessWidget {
  // Indicates whether the profile belongs to the current user.
  final bool isCurrentUser;

  // Indicates whether the current user is following this profile.
  final bool isFollowing;

  const ProfileButton({
    super.key,
    required this.isCurrentUser,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    // Show 'Edit Profile' button for the current user, otherwise show 'Follow/Unfollow' button.
    return isCurrentUser
        ? buildEditProfileButton(context)
        : buildFollowButton(context);
  }

  // Builds the 'Edit Profile' button.
  TextButton buildEditProfileButton(BuildContext context) {
    return TextButton(
      onPressed: () => navigateToEditProfile(context),
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          // Ajoute des bords arrondis
          borderRadius: BorderRadius.circular(10), // Rayon des bords arrondis
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.translate('editProfile'),
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }

  // Navigates to the 'Edit Profile' screen.
  void navigateToEditProfile(BuildContext context) {
    GoRouter.of(context).push('/profile/editprofile');
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
        isFollowing ? AppLocalizations.of(context)!.translate('unfollow'): AppLocalizations.of(context)!.translate('follow'),
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
