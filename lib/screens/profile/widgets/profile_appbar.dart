import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProfileState state;
  final BuildContext parentContext;
  const ProfileAppBar(
      {Key? key, required this.parentContext, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildProfileAppBar(context, state);
  }

  AppBar _buildProfileAppBar(BuildContext context, ProfileState state) {
    return AppBar(
      backgroundColor: white,
      iconTheme: const IconThemeData(
        color: black,
      ),
      elevation: 0,
      centerTitle: true,
      title: Text(
        state.user.username,
        style: const TextStyle(color: black),
      ),
      actions: _buildAppBarActions(context, state),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, ProfileState state) {
    if (state.isCurrentUser) {
      return [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            GoRouter.of(context).go('/profile/settings');
          },
        ),
      ];
    }
    return [];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
