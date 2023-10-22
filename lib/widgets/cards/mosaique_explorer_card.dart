import 'package:flutter/material.dart';

class MosaiqueExplorerCard extends StatelessWidget {
  final String imageUrl;

  const MosaiqueExplorerCard({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl);
  }

  Widget _buildCard(
      BuildContext context, String imageUrl) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              _buildPost(imageUrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
