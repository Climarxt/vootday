import 'package:bootdv2/screens/home/widgets/feedootd.dart';
import 'package:bootdv2/screens/home/widgets/feedevent.dart';
import 'package:bootdv2/screens/home/widgets/feedmonth.dart';
import 'package:bootdv2/screens/home/widgets/tabbar3items.dart';
import 'package:flutter/material.dart';

class HomeScreenSave extends StatefulWidget {
  const HomeScreenSave({super.key});

  @override
  State<HomeScreenSave> createState() => _HomeScreenSaveState();
}

class _HomeScreenSaveState extends State<HomeScreenSave>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreenSave> {
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
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: Tabbar3items(tabController: _tabController, context: context),
          body: _buildBody(),
        );
      }
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
          FeedCalendar(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
