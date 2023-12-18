import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/screens/follow_users/widgets/follow_users_tile.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_cubit.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_state.dart';

class FollowingUsersList extends StatefulWidget {
  const FollowingUsersList({super.key});

  @override
  State<FollowingUsersList> createState() => _FollowingUsersListState();
}

class _FollowingUsersListState extends State<FollowingUsersList> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.uid;
    context.read<FollowersUsersCubit>().fetchUserFollowers(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowersUsersCubit, FollowersUsersState>(
      listener: (context, state) {},
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(FollowersUsersState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: state.followers.length,
        itemBuilder: (context, index) {
          final user = state.followers[index];
          return FollowUsersTile(
            user: user,
          );
        },
      ),
    );
  }
}
