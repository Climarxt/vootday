import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

// ignore: must_be_immutable
class TabbarMyProfile extends StatelessWidget {
  final TabController? tabController;

  const TabbarMyProfile({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = const [
      Tab(icon: Icon(Icons.border_all)),
      Tab(icon: Icon(Icons.view_list)),
      Tab(icon: Icon(Icons.bookmark_border)),
      Tab(icon: Icon(Icons.favorite)),
    ];
    return TabBar(
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: RectangularIndicator(
        color: couleurBleuClair2,
        horizontalPadding: 12,
        verticalPadding: 4,
        bottomLeftRadius: 100,
        bottomRightRadius: 100,
        topLeftRadius: 100,
        topRightRadius: 100,
      ),
      labelStyle: Theme.of(context).textTheme.headlineMedium!,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      unselectedLabelStyle: Theme.of(context).textTheme.headlineMedium,
      tabs: tabs,
    );
  }
}
