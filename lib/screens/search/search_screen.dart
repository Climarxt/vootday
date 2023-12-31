import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/screens.dart';
import 'package:bootdv2/screens/search/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SearchScreen> {
  // final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

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
          Tabbar2itemsSearch(tabController: _tabController, context: context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        FollowingScreen(),
        ExplorerScreen(),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToSearchingScreen(context),
      label: Text(AppLocalizations.of(context)!.translate('search'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white)),
      backgroundColor: couleurBleuClair2,
    );
  }

  void _navigateToSearchingScreen(BuildContext context) {
    GoRouter.of(context).push('/search/searching');
  }

  @override
  bool get wantKeepAlive => true;
}
