import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/screens/profile/profile_tab1.dart';
import 'package:bootdv2/screens/profile/profile_tab3.dart';
import 'package:bootdv2/screens/profile/widgets/tabbar_profile.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:bootdv2/widgets/appbar/appbar_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenArgs {
  final String userId;

  const ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Route route({required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: const ProfileScreen(),
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return DefaultTabController(
        length: 3,
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
              const ProfileTab1(),
              ProfileTab2(context: context, state: state),
              const ProfileTab3(),
            ],
          ),
        ),
      );
    });
  }
}

class ProfileTabbar extends SliverPersistentHeaderDelegate {
  final Widget child;

  ProfileTabbar({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 48;

  @override
  // TODO: implement minExtent
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class ProfileHeader extends StatelessWidget {
  final ProfileState state;
  const ProfileHeader({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
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
    );
  }
}
