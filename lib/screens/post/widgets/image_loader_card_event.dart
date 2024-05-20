// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageLoaderCardEvent extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageLoaderCardEvent({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  _ImageLoaderCardEventState createState() => _ImageLoaderCardEventState();
}

class _ImageLoaderCardEventState extends State<ImageLoaderCardEvent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
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
        SvgPicture.network(
          widget.imageUrl,
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
