import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

// ignore: must_be_immutable
class Tabbar2items extends StatelessWidget implements PreferredSizeWidget {
  late TabController tabController;
  final BuildContext context;
  Tabbar2items({
    Key? key,
    required this.tabController,
    required this.context,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(62);
  
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = const [
      Tab(child: Text("OOTD")),
      Tab(child: Text("Event")),
    ];
    return AppBar(
      toolbarHeight: 62,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      elevation: 0,
      title: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: RectangularIndicator(
              color: couleurBleuClair2,
              horizontalPadding: 20,
              verticalPadding: 4,
              bottomLeftRadius: 100,
              bottomRightRadius: 100,
              topLeftRadius: 100,
              topRightRadius: 100,
            ),
            controller: tabController,
            labelStyle: Theme.of(context).textTheme.headlineMedium!,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: Theme.of(context).textTheme.headlineMedium,
            tabs: tabs,
          ),
        ],
      ),
    );
  }
}
