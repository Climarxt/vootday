import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/screens/profile/bloc/profile_bloc.dart';

class ProfileButton extends StatelessWidget {
  // Indicates whether the profile belongs to the current user.
  final bool isCurrentUser;

  // Indicates whether the current user is following this profile.
  final bool isFollowing;

  const ProfileButton({
    Key? key,
    required this.isCurrentUser,
    required this.isFollowing,
  }) : super(key: key);

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
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          // Ajoute des bords arrondis
          borderRadius: BorderRadius.circular(18), // Rayon des bords arrondis
        ),
      ),
      child: const Text(
        'Edit Profile',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }

  // Navigates to the 'Edit Profile' screen.
  void navigateToEditProfile(BuildContext context) {
    GoRouter.of(context).go('/profile/editprofile');
  }

  // Builds the 'Follow/Unfollow' button.
  TextButton buildFollowButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isFollowing ? Colors.grey[300] : couleurBleuClair2,
      ),
      onPressed: () => toggleFollowStatus(context),
      child: Text(
        isFollowing ? 'Unfollow' : 'Follow',
        style: TextStyle(
          fontSize: 16.0,
          color: isFollowing ? Colors.black : Colors.white,
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
