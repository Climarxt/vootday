import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MosaiqueEventLargeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const MosaiqueEventLargeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = size.width * 0.6;
    return GestureDetector(
      child: SizedBox(
        width: cardWidth,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
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
        SvgPicture.network(
          imageUrl,
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
        )
      ],
    );
  }
}
