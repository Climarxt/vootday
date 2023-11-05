import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MosaiqueProfileCard extends StatelessWidget {
  final String imageUrl;

  const MosaiqueProfileCard(
    BuildContext context, {
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl);
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10),
          child: CachedNetworkImage(
            fadeInDuration: const Duration(microseconds: 0),
            fadeOutDuration: const Duration(microseconds: 0),
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
