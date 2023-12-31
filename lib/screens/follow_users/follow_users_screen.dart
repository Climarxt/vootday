import 'package:bootdv2/screens/follow_users/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FollowUsersScreen extends StatefulWidget {
  final String userId;
  final int initialTabIndex;

  const FollowUsersScreen({
    super.key,
    required this.userId,
    required this.initialTabIndex,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FollowUsersScreenState createState() => _FollowUsersScreenState();
}

class _FollowUsersScreenState extends State<FollowUsersScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FollowUsersScreen> {
  // final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  // final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
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
      appBar: Tabbar2items(tabController: _tabController, context: context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        FollowingUsersList(
          userId: widget.userId,
        ),
        FollowersUsersList(
          userId: widget.userId,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
