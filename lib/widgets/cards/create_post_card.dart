import 'package:flutter/material.dart';
import 'dart:io';

class CreatePostCard extends StatelessWidget {
  final File? postImage;

  const CreatePostCard({
    Key? key,
    this.postImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      child: SizedBox(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: postImage != null ? _buildPost() : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPost() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(postImage!),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.image,
        color: Colors.grey,
        size: 120.0,
      ),
    );
  }
}
