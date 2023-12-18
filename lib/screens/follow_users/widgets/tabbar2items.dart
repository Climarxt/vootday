import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      Tab(child: Text("Following")),
      Tab(child: Text("Followers")),
    ];
    return AppBar(
      toolbarHeight: 62,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          final goRouter = GoRouter.of(context);
          goRouter.go('/profile');
        },
      ),
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
