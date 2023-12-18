import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/screens/follow_users/widgets/follow_users_tile.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_cubit.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_state.dart';

class FollowersUsersList extends StatefulWidget {
  final String userId;
  const FollowersUsersList({
    super.key,
    required this.userId,
  });

  @override
  State<FollowersUsersList> createState() => _FollowersUsersListState();
}

class _FollowersUsersListState extends State<FollowersUsersList> {
  List<bool> isFollowingList = [];

  @override
  void initState() {
    super.initState();
    context.read<FollowersUsersCubit>().fetchUserFollowers(widget.userId);
  }

  // Check si user de la liste et suivi ou non
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
    return BlocListener<FollowersUsersCubit, FollowersUsersState>(
      listener: (context, state) {
        if (state.status == FollowersUsersStatus.loaded) {
          _fetchFollowingStatus(state.followers);
        }
      },
      child: Builder(
        builder: (context) {
          final state = context.watch<FollowersUsersCubit>().state;

          if (state.status == FollowersUsersStatus.loading) {
            return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent));
          }

          if (state.status == FollowersUsersStatus.loaded) {
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
