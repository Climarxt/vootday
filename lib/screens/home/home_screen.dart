import 'package:flutter/material.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/post/postscreen.dart';

import '../../import/dummy.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<int> _data = List.generate(8, (index) => index); // Initial data
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void _navigateToDetailsPage(BuildContext context, Map<String, dynamic> item,
      Object heroTag, Object profileTag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: PostScreen(
            title: item['name'] ?? 'default',
            imageUrl: item['imageUrl'] ?? 'default',
            profileUrl: item['profileUrl'] ?? 'default',
            heroTag: heroTag,
            profileTag: profileTag,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
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
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue,
            ),
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black, // Changer la couleur ici
            tabs: tabs,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTabContent(),
        _buildTabContent(),
        _buildTabContent(),
      ],
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
      final Object heroTag = UniqueKey();
      final Object profileTag = UniqueKey();
      return _buildCard(context, item, heroTag, profileTag, size);
    }
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox();
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> item,
      Object heroTag, Object profileTag, Size size) {
    return GestureDetector(
      onTap: () => _navigateToDetailsPage(context, item, heroTag, profileTag),
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Commentez cette ligne pour déboguer
              _buildHero(item, heroTag),
              Align(
                alignment: Alignment.topLeft,
                child: _buildProfileAvatar(item, profileTag),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(Map<String, dynamic> item, Object heroTag) {
    return Hero(
      tag: heroTag,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(item['imageUrl'] ?? 'default'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }

  Widget _buildProfileAvatar(Map<String, dynamic> item, Object profileTag) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Hero(
            tag: profileTag,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  item['profileUrl']!,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item['name']!,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: white,
              shadows: [
                Shadow(offset: Offset(-0.2, -0.2), color: Colors.grey),
                Shadow(offset: Offset(0.2, -0.2), color: Colors.grey),
                Shadow(offset: Offset(0.2, 0.2), color: Colors.grey),
                Shadow(offset: Offset(-0.2, 0.2), color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Tab> tabs = [
    const Tab(
      child: Text(
        "MONTH",
      ),
    ),
    const Tab(
      child: Text(
        "DAY",
      ),
    ),
    const Tab(
      child: Text(
        "EVENT",
      ),
    ),
  ];
}
