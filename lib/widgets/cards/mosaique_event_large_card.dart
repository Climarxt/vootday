import 'package:bootdv2/screens/post/widgets/image_loader_card_event.dart';
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
    double cardHeight = size.height * 0.2;
    return GestureDetector(
      child: SizedBox(
        width: cardWidth,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Center(child: _buildPost(imageUrl, cardWidth, cardHeight)),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl, double width, double height) {
    return ImageLoaderCardEvent(
      imageUrl: imageUrl,
      width: width,
      height: height,
    );
  }
}
