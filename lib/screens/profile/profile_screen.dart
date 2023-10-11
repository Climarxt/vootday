// External packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Internal packages
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/repositories/repositories.dart';

// Project specific files
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:bootdv2/widgets/widgets.dart';

// Constants
const double userProfileImageRadius = 50.0;
const double outerCircleRadius = 51;

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

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _forceLoading = true;

  @override
  void initState() {
    super.initState();
    _initTabController();
    _simulateLoading();
  }

  // Initialize the tab controller
  void _initTabController() {
    _tabController = TabController(length: 2, vsync: this);
  }

  // Simulate initial loading
  void _simulateLoading() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _forceLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: _buildProfileScreen);
  }

  // Build the main profile screen
  Widget _buildProfileScreen(BuildContext context, ProfileState state) {
    if (_forceLoading) {
      return _buildLoadingState(state);
    }

    if (state.status == ProfileStatus.loaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(state),
        body: _buildBody(context, state),
      );
    } else {
      return _buildErrorState(state);
    }
  }

  // Build the Loading State
  Widget _buildLoadingState(ProfileState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(state),
      body: Stack(
        children: [
          Offstage(
            child: _buildBody(context, state),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  // Build the Loading Error State
  Widget _buildErrorState(ProfileState state) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Something went wrong.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Build the app bar
  PreferredSize _buildAppBar(ProfileState state) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: AppBar(
        centerTitle: true,
        title: Text(
          state.user.username,
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [_buildSettingsButton(context)],
      ),
    );
  }

  /* Build settings button
  IconButton _buildSettingsButton(BuildContext context) {
    return IconButton(
      onPressed: () => GoRouter.of(context).go('/profile/settings'),
      icon: const Icon(Icons.settings, color: Colors.black),
    );
  }
  */

  // Build settings button
IconButton _buildSettingsButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    },
    icon: const Icon(Icons.settings, color: Colors.black),
  );
}


  // Build the main body
  Widget _buildBody(BuildContext context, ProfileState state) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              
              delegate: SliverChildListDelegate(
                [
                  UserProfileImage(
                    radius: 50.0,
                    outerCircleRadius: 51,
                    profileImageUrl: state.user.profileImageUrl,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ProfileStats(
                      isCurrentUser: state.isCurrentUser,
                      isFollowing: state.isFollowing,
                      posts: state.posts.length,
                      followers: state.user.followers,
                      following: state.user.following,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.grid_view)),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PersistentGridView(),
                  PersistentListView(context: context, state: state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
