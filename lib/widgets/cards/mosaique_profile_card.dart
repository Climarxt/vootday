import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MosaiqueProfileCard extends StatefulWidget {
  final String imageUrl;

  const MosaiqueProfileCard({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _MosaiqueProfileCardState createState() => _MosaiqueProfileCardState();
}

class _MosaiqueProfileCardState extends State<MosaiqueProfileCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  bool _isImageLoaded = false; // Ajout d'un booléen pour suivre si l'image est chargée

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Durée de l'animation de fondu
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isImageLoaded = true; // L'image est chargée une fois que l'animation est terminée
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: _opacityAnimation,
      child: GestureDetector(
        child: SizedBox(
          height: size.height * 0.6,
          width: size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _isImageLoaded ? CachedNetworkImage( // L'image est chargée ici si _isImageLoaded est vrai
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
            ) : Container(color: Colors.transparent), // Un conteneur transparent est affiché pendant le fondu
          ),
        ),
      ),
    );
  }
}
