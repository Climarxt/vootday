import 'package:bootdv2/widgets/cards/mosaique_explorer_card.dart';
import 'package:flutter/material.dart';

class SearchExplorer extends StatefulWidget {
  const SearchExplorer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchExplorerState createState() => _SearchExplorerState();
}

class _SearchExplorerState extends State<SearchExplorer> {
  List<String> imageList = [
    'assets/images/postImage.jpg',
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG3_2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8,
        ),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return _buildCard(context, imageList[index]);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    return MosaiqueExplorerCard(
      imageUrl: imageUrl,
    );
  }
}
