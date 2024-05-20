// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ImageSVGLoader extends StatefulWidget {
  final ImageProvider imageProvider;
  final double width;
  final double height;

  const ImageSVGLoader({
    super.key,
    required this.imageProvider,
    required this.width,
    required this.height,
  });

  @override
  _ImageSVGLoaderState createState() => _ImageSVGLoaderState();
}

class _ImageSVGLoaderState extends State<ImageSVGLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: widget.imageProvider,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(_animation.value),
          ),
        ),
      ],
    );
  }
}
