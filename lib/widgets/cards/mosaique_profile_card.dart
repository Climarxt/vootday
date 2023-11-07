import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MosaiqueProfileCard extends StatefulWidget {
  final String imageUrl;

  const MosaiqueProfileCard({
    super.key,
    required this.imageUrl,
  });

  @override
  State<MosaiqueProfileCard> createState() => _MosaiqueProfileCardState();
}

class _MosaiqueProfileCardState extends State<MosaiqueProfileCard> {
  bool isImageVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay the visibility of the image
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          isImageVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isImageVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: isImageVisible
          ? _buildCard(context, widget.imageUrl)
          : Container(
              color: Colors.white), // White container is the placeholder
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
