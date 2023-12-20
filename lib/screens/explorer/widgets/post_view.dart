import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';

class PostView extends StatefulWidget {
  final Post post;

  PostView({
    Key? key,
    required this.post,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  // ignore: library_private_types_in_public_api
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with SingleTickerProviderStateMixin {
  bool isImageVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
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
      duration: const Duration(milliseconds: 300),
      child: isImageVisible
          ? Bounceable(
              onTap: () => _navigateToPostScreen(context),
              child: _buildPost(context),
            )
          : Container(color: white),
    );
  }

  Widget _buildPost(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: double.infinity,
      child: Stack(
        children: [
          _buildImage(widget.post.imageProvider),
        ],
      ),
    );
  }

  Widget _buildImage(CachedNetworkImageProvider imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final username = widget.post.author.username;
    GoRouter.of(context).push('/post/${widget.post.id}?username=$username');
  }
}
