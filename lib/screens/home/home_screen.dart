import 'package:bootdv2/screens/home/widgets/feedday.dart';
import 'package:bootdv2/screens/home/widgets/feedevent.dart';
import 'package:bootdv2/screens/home/widgets/feedmonth.dart';
import 'package:bootdv2/screens/home/widgets/profileimagefeed.dart';
import 'package:bootdv2/screens/home/widgets/tabbar3items.dart';
import 'package:flutter/material.dart';

import '../../import/dummy.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

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
    return Scaffold(
      appBar: Tabbar3items(tabController: _tabController, context: context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12,0,12,0),
      child: TabBarView(
        controller: _tabController,
        children: [
          FeedDay(),
          FeedMonth(),
          FeedEvent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length + 1,
      itemBuilder: (context, index) => _buildItem(context, index, size),
    );
  }

  Widget _buildItem(BuildContext context, int index, Size size) {
    if (index < data.length) {
      var item = data[index];
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: _buildCard(context, item, size),
      );
    }
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox();
  }

  Widget _buildCard(
      BuildContext context, Map<String, dynamic> item, Size size) {
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              _buildPost(),
              const Align(
                alignment: Alignment.topLeft,
                child: ProfileImageFeed(
                  username: "ct.bast",
                  profileUrl: ('assets/images/profile2.jpg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: const DecorationImage(
                image: AssetImage('assets/images/postImage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
