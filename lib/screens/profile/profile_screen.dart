import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/screens/profile/profile_tab1.dart';
import 'package:bootdv2/screens/profile/profile_tab3.dart';
import 'package:bootdv2/screens/profile/widgets/tabbar_profile.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:bootdv2/widgets/appbar/appbar_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadUser(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProfileStatus.error) {
          return Center(child: Text(state.failure.message));
        }
        // Maintenant que le ProfileBloc est accessible, construisez l'UI
        return DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBarProfile(title: state.user.username),
                SliverToBoxAdapter(child: ProfileHeader(state: state)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ProfileTabbar(
                    child: Container(
                      color: Colors.white,
                      child: const TabbarProfile(),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  ProfileTab1(context: context, state: state),
                  ProfileTab2(context: context, state: state),
                  const ProfileTab3(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileTabbar extends SliverPersistentHeaderDelegate {
  final Widget child;

  ProfileTabbar({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Ajouter un Material widget ici pour s'assurer que le TabBar a un ancêtre Material
    return Material(
      child: child,
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class ProfileHeader extends StatelessWidget {
  final ProfileState state;
  const ProfileHeader({
    super.key,
    required this.state,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      color: white,
      child: Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile1.jpg'),
            ),
            const SizedBox(height: 8),
            Text(
              'Christian Bastide',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: black),
            ),
            const SizedBox(height: 12),
            ProfileStats(
              isCurrentUser: state.isCurrentUser,
              isFollowing: state.isFollowing,
              posts: state.posts.length,
              followers: state.user.followers,
              following: state.user.following,
            ),
            const SizedBox(height: 8), // Bottom space
          ],
        ),
      ),
    );
  }
}
