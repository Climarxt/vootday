import 'package:bootdv2/screens/home/feed_ootd.dart';
import 'package:bootdv2/screens/home/home_event.dart';
import 'package:bootdv2/screens/home/feed_month.dart';
import 'package:bootdv2/screens/home/widgets/tabbar3items.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: Tabbar3items(tabController: _tabController, context: context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TabBarView(
        controller: _tabController,
        children: [
          FeedOOTD(),
          FeedMonth(),
          HomeEvent(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
