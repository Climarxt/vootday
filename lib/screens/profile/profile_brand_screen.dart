import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/profiles.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileBrandScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String title;
  const ProfileBrandScreen({
    super.key,
    required this.userId,
    required this.title,
    required this.username,
  });

  @override
  State<ProfileBrandScreen> createState() => _ProfileBrandScreenState();
}

class _ProfileBrandScreenState extends State<ProfileBrandScreen> {
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
        if (state.status == ProfileStatus.initial) {
          return Container(color: white);
        }
        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProfileStatus.error) {
          return Center(child: Text(state.failure.message));
        }
        return Container(
          color: Colors.white,
          child: DefaultTabController(
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

class ProfileHeader extends StatefulWidget {
  final ProfileState state;

  const ProfileHeader({
    super.key,
    required this.state,
  });

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser widget.state pour accéder à l'état passé à ProfileHeader
    return Container(
      color: Colors
          .white, // Assurez-vous que `Colors.white` est importé correctement
      child: Center(
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 300),
              child: CircleAvatar(
                backgroundColor: white,
                radius: 50,
                child: SvgPicture.network(
                  widget.state.user.profileImageUrl,
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 300),
              child: Text(
                '${widget.state.user.firstName} ${widget.state.user.lastName}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            ProfileStats(
              isCurrentUser: widget.state.isCurrentUser,
              isFollowing: widget.state.isFollowing,
              posts: widget.state.posts.length,
              followers: widget.state.user.followers,
              following: widget.state.user.following,
            ),
            const SizedBox(height: 8), // Bottom space
          ],
        ),
      ),
    );
  }
}
