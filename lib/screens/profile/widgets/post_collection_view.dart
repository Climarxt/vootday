import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCollectionView extends StatefulWidget {
  final Post post;
  final String collectionId;
  final String title;

  PostCollectionView({
    Key? key,
    required this.post,
    required this.title,
    required this.collectionId,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  _PostCollectionViewState createState() => _PostCollectionViewState();
}

class _PostCollectionViewState extends State<PostCollectionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: () => _navigateToPostScreen(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Stack(
                children: [
                  ImageLoaderPostEvent(
                    imageProvider: widget.post.imageProvider,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final String encodedUsername =
        Uri.encodeComponent(widget.post.author.username);
    final String encodedTitle = Uri.encodeComponent(widget.title);

    GoRouter.of(context)
        .push('/profile/collection/${widget.collectionId}/post/${widget.post.id}'
            '?username=$encodedUsername'
            '&title=$encodedTitle');
  }
}
