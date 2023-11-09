import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  final ImageProvider imageProvider;
  final double width;
  final double height;

  const ImageLoader({
    Key? key,
    required this.imageProvider,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader>
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
