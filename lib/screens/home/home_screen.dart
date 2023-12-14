import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/home/feed_ootd.dart';
import 'package:bootdv2/screens/home/home_event.dart';
import 'package:bootdv2/screens/home/feed_month.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) {
        return ProfileBloc(
          authBloc: context.read<AuthBloc>(),
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
        );
      },
      child: Scaffold(
        appBar: Tabbar3items(tabController: _tabController, context: context),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        FeedOOTD(),
        FeedMonth(),
        HomeEvent(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
