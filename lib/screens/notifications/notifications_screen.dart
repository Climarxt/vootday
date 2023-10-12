import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/notifications/widgets/notifications_list.dart';
import 'package:bootdv2/screens/notifications/widgets/tabbar2itemsnotif.dart';
import 'package:bootdv2/screens/search/widgets/search_explorer.dart';
import 'package:bootdv2/screens/search/widgets/search_following.dart';
import 'package:bootdv2/screens/search/widgets/tabbar2itemssearch.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<NotificationScreen> {
  // final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final SearchController _searchController = SearchController();

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
