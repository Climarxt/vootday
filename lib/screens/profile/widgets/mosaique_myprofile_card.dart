import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/models.dart';

class MosaiqueMyProfileCard extends StatefulWidget {
  final Post post;

  const MosaiqueMyProfileCard({
    super.key,
    required this.post,
  });

  @override
  State<MosaiqueMyProfileCard> createState() => _MosaiqueMyProfileCardState();
}

class _MosaiqueMyProfileCardState extends State<MosaiqueMyProfileCard> {
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
          ? GestureDetector(
              onTap: () => _navigateToPostScreen(context),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : Container(color: Colors.white),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final username = widget.post.author.username;
    GoRouter.of(context)
        .push('/post/${widget.post.id}?username=$username');
  }
}
