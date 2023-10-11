import 'package:flutter/material.dart';
import 'package:bootdv2/config/configs.dart';

class SwipeScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SwipeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  // final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context, size),
      ),
    );
  }

  // Création d'une fonction pour le corps
  Widget _buildBody(BuildContext context, Size size) {
    return _buildDefaultState(size);
  }

  // Création d'une fonction pour l'état par défaut
  Widget _buildDefaultState(Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPost(
                size,
                'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_e5af98f9-7adb-478f-8a18-71d897d3e68b.jpg?alt=media&token=ace3779f-cc7d-4f0f-a23c-35719ab4c3d2',
                'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_e5af98f9-7adb-478f-8a18-71d897d3e68b.jpg?alt=media&token=ace3779f-cc7d-4f0f-a23c-35719ab4c3d2'),
            const Divider(),
            _buildPost(
                size,
                'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_4def9ea3-d748-41c4-9a4d-5e042e386616.jpg?alt=media&token=433cc76c-6c47-4218-aad1-e5ebf63a943e',
                'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_4def9ea3-d748-41c4-9a4d-5e042e386616.jpg?alt=media&token=433cc76c-6c47-4218-aad1-e5ebf63a943e'),
          ],
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

  List<Tab> tabs = [
    const Tab(
      child: Text(
        "OOTD",
      ),
    ),
    const Tab(
      child: Text(
        "EVENT",
      ),
    ),
  ];

  // Création d'une fonction pour construire chaque post
  Widget _buildPost(Size size, String imageUrl, String profileImageUrl) {
    // <-- Add profileImageUrl parameter
    return AspectRatio(
      aspectRatio: 1.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // <-- White border color
                              width: 2.0, // <-- Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileImageUrl),
                            radius: 15,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "NomUtilisateur",
                          style: TextStyle(
                            fontSize: 20,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
