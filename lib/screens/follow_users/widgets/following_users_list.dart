import 'package:bootdv2/screens/follow_users/following_users/following_users_cubit.dart';
import 'package:bootdv2/screens/follow_users/following_users/following_users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/screens/follow_users/widgets/follow_users_tile.dart';

class FollowingUsersList extends StatefulWidget {
  final String userId;

  const FollowingUsersList({
    super.key,
    required this.userId,
  });

  @override
  State<FollowingUsersList> createState() => _FollowingUsersListState();
}

class _FollowingUsersListState extends State<FollowingUsersList> {
  @override
  void initState() {
    super.initState();
    context.read<FollowingUsersCubit>().fetchUserFollowers(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowingUsersCubit, FollowingUsersState>(
      listener: (context, state) {},
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(FollowingUsersState state) {
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
