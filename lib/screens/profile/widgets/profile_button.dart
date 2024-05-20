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
    // Show 'Edit Profile' buttons for the current user, otherwise show 'Follow/Unfollow' button.
    return isCurrentUser
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildEditProfileButton(context),
              const SizedBox(width: 12),
              buildAddPhotoButton(context),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildMessageButton(context),
              const SizedBox(width: 12),
              buildFollowButton(context),
            ],
          );
  }

  // Builds the 'Edit Profile' button.
  Widget buildEditProfileButton(BuildContext context) {
    return SizedBox(
      width: 160, // Fixed width for consistency
      child: TextButton(
        onPressed: () => navigateToEditProfile(context),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          backgroundColor: grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            AppLocalizations.of(context)!.translate('edit'),
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: black),
          ),
        ),
      ),
    );
  }

  // Builds the 'Add' button.
  Widget buildAddPhotoButton(BuildContext context) {
    return SizedBox(
      width: 160, // Fixed width for consistency
      child: TextButton(
        onPressed: () => GoRouter.of(context).go('/profile/create'),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          backgroundColor: couleurBleuClair2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            AppLocalizations.of(context)!.translate('add'),
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: white),
          ),
        ),
      ),
    );
  }

  // Builds the 'Message' button.
  Widget buildMessageButton(BuildContext context) {
    return SizedBox(
      width: 160, // Fixed width for consistency
      child: TextButton(
        onPressed: () => GoRouter.of(context).push('/message'),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          backgroundColor: grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "Message",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: black),
          ),
        ),
      ),
    );
  }

  // Navigates to the 'Edit Profile' screen.
  void navigateToEditProfile(BuildContext context) {
    GoRouter.of(context).push('/editprofile');
  }

  // Builds the 'Follow/Unfollow' button.
  Widget buildFollowButton(BuildContext context) {
    return SizedBox(
      width: 160, // Fixed width for consistency
      child: TextButton(
        onPressed: () => toggleFollowStatus(context),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          backgroundColor: couleurBleuClair2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            isFollowing
                ? AppLocalizations.of(context)!.translate('unfollow')
                : AppLocalizations.of(context)!.translate('follow'),
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: white),
          ),
        ),
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
