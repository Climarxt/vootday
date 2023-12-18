import 'package:bootdv2/screens/notifications/widgets/widgets.dart';

import 'package:flutter/material.dart';

class FollowersFollowingScreenScreen extends StatefulWidget {
  const FollowersFollowingScreenScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FollowersFollowingScreenScreenState createState() => _FollowersFollowingScreenScreenState();
}

class _FollowersFollowingScreenScreenState extends State<FollowersFollowingScreenScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FollowersFollowingScreenScreen> {
  // final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  // final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar:
          Tabbar2itemsNotif(tabController: _tabController, context: context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TabBarView(
        controller: _tabController,
        children: const [
          NotificationsList(),
          NotificationsList(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
