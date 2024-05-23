import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

// ignore: must_be_immutable
class Tabbar2items extends StatelessWidget implements PreferredSizeWidget {
  late TabController tabController;
  final BuildContext context;
  Tabbar2items({
    super.key,
    required this.tabController,
    required this.context,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = const [
      Tab(child: Text("OOTD")),
      Tab(child: Text("Event")),
    ];
    return SafeArea(
      child: TabBar(
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: RectangularIndicator(
          color: couleurBleuClair2,
          horizontalPadding: 16,
          verticalPadding: 6,
          bottomLeftRadius: 100,
          bottomRightRadius: 100,
          topLeftRadius: 100,
          topRightRadius: 100,
        ),
        controller: tabController,
        labelStyle: Theme.of(context).textTheme.headlineMedium!,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: Theme.of(context).textTheme.headlineMedium,
        tabs: tabs,
      ),
    );
  }
}
