import 'package:bootdv2/screens/home/widgets/feedday.dart';
import 'package:bootdv2/screens/home/widgets/feedevent.dart';
import 'package:bootdv2/screens/home/widgets/feedmonth.dart';
import 'package:bootdv2/screens/home/widgets/tabbar3items.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> {
  // Added mixin
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
    super.build(context); // Call this method for the mixin to work
    return Scaffold(
      appBar: Tabbar3items(tabController: _tabController, context: context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: TabBarView(
        controller: _tabController,
        children: const [
          FeedDay(),
          FeedMonth(),
          FeedEvent(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // Overridden to retain the state
}
