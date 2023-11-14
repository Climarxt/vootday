import 'package:bootdv2/screens/post/widgets/image_loader_card_event.dart';
import 'package:flutter/material.dart';

class MosaiqueEventLargeCard extends StatefulWidget {
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
  State<MosaiqueEventLargeCard> createState() => _MosaiqueEventLargeCardState();
}

class _MosaiqueEventLargeCardState extends State<MosaiqueEventLargeCard> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = size.width * 0.6;
    double cardHeight = size.height * 0.2;
    return GestureDetector(
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          width: cardWidth,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Center(
                child: _buildPost(widget.imageUrl, cardWidth, cardHeight)),
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl, double width, double height) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 700),
      child: ImageLoaderCardEvent(
        imageUrl: imageUrl,
        width: width,
        height: height,
      ),
    );
  }
}
