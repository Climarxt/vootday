import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/screens.dart';
import 'package:bootdv2/screens/search/widgets/widgets.dart';

import 'package:flutter/material.dart';

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
          Tabbar2itemsSearch(tabController: _tabController, context: context),
      body: _buildBody(),
      floatingActionButton: SearchAnchor(
        searchController: _searchController,
        builder: (BuildContext context, SearchController controller) {
          return FloatingActionButton.extended(
            onPressed: () {
              controller.openView();
            },
            label: Text(AppLocalizations.of(context)!.translate('search'),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white)),
            backgroundColor: couleurBleuClair2,
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TabBarView(
        controller: _tabController,
        children: [
          FollowingScreen(),
          SearchExplorer(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
