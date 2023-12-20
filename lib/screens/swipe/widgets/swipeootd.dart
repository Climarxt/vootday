import 'package:flutter/material.dart';

class SwipeOOTD extends StatefulWidget {
  const SwipeOOTD({super.key});

  @override
  State<SwipeOOTD> createState() => _SwipeOOTDState();
}

class _SwipeOOTDState extends State<SwipeOOTD> {
  final List<String> _imageUrls = [
    // Ajoutez toutes vos URLs d'images ici
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG3_2.jpg',
  ];

  late String _imageUrl1;
  late String _imageUrl2;

  @override
  void initState() {
    super.initState();
    _refreshImages();
  }

  void _refreshImages() {
    // Mélangez la liste et prenez les deux premières images
    setState(() {
      _imageUrls.shuffle();
      _imageUrl1 = _imageUrls[0];
      _imageUrl2 = _imageUrls[1];
    });
  }

  void _onImageTap() {
    // Lorsqu'une image est sélectionnée, rafraîchissez les deux images
    _refreshImages();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _onImageTap,
            child: _buildCard(_imageUrl1, size),
          ),
          SizedBox(height: 2),
          GestureDetector(
            onTap: _onImageTap,
            child: _buildCard(_imageUrl2, size),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String imageUrl, Size size) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AspectRatio(
        aspectRatio: 1.17,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
