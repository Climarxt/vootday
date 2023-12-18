import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
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
  List<bool> isFollowingList = [];

  @override
  void initState() {
    super.initState();
    context.read<FollowingUsersCubit>().fetchUserFollowing(widget.userId);
  }

  Future<void> _fetchFollowingStatus(List<User> followers) async {
    isFollowingList = [];
    for (var user in followers) {
      var isFollowing = await context.read<UserRepository>().isFollowing(
            userId: context.read<AuthBloc>().state.user!.uid,
            otherUserId: user.id,
          );
      isFollowingList.add(isFollowing);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowingUsersCubit, FollowingUsersState>(
      listener: (context, state) {
        if (state.status == FollowingUsersStatus.loaded) {
          _fetchFollowingStatus(state.followers);
        }
      },
      child: Builder(
        builder: (context) {
          final state = context.watch<FollowingUsersCubit>().state;

          if (state.status == FollowingUsersStatus.loading) {
            return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent));
          }

          if (state.status == FollowingUsersStatus.loaded) {
            return _buildFollowersList(state.followers);
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildFollowersList(List<User> followers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final user = followers[index];
          final isFollowing =
              isFollowingList.length > index ? isFollowingList[index] : false;
          return FollowUsersTile(
            user: user,
            isFollowing: isFollowing,
          );
        },
      ),
    );
  }
}
